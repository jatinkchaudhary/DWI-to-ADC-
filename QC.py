import PIL
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw
import numpy as np
import nibabel as nib
import os
from argparse import ArgumentParser

#!/usr/bin/env python

####################################################################
# Python 2.7 script for executing FA, MD calculations for one case #
####################################################################

def write_QC_scales_maskfusion(img, mask, filename, scales, offset, alpha, flip):

    # Resolve size of output image
    totalx = 0
    totaly = 0
    imagedatas = []
    maskdatas = []
    print("Loading " + img)
    imagedata = np.asanyarray(nib.load(img).dataobj)
    print("Loading " + mask)
    maskdata = np.asanyarray(nib.load(mask).dataobj)
    
    ystart = 0
    xstart = 0
    img_x = imagedata.shape[0]-2*offset
    img_y = imagedata.shape[1]-2*offset
    x_ready = False
    for img_i in range(imagedata.shape[2]):
        if np.max(maskdata[:, :, img_i]) == 0:
            continue
        imagedatas.append(np.rot90(imagedata[offset:imagedata.shape[0]-offset, offset:imagedata.shape[1]-offset, img_i]))
        maskdatas.append(np.rot90(maskdata[offset:imagedata.shape[0]-offset, offset:imagedata.shape[1]-offset, img_i]))
        if len(maskdatas) % 5 == 0:
            xstart = 0
            ystart = ystart + img_y
            x_ready = True
        else:
            if not x_ready:
                xstart = xstart + img_x
    if len(maskdatas) == 0:
        return 0

    totalx = img_x*5
    totaly = ystart + img_y
    data = np.zeros((totaly,totalx))
    mask = np.zeros((totaly,totalx))
    print(data.shape)
    ystart = 0
    xstart = 0
    img_x = imagedatas[0].shape[0]
    img_y = imagedatas[0].shape[1]
    print((img_x, img_y))

    for img_i in range(len(imagedatas)):
        img_trans = imagedatas[img_i][:,:]
        img_mask = maskdatas[img_i][:,:]
        
        if flip == 'lr':
            img_trans = np.fliplr(img_trans)
            img_mask = np.fliplr(img_mask)
        if flip == 'ud':
            img_trans = np.flipud(img_trans)
            img_mask = np.flipud(img_mask)
        
        img_max = scales[0]*np.mean(img_trans)
        if img_i == 0:
            img_trans_0 = img_trans
            img_max_0 = img_max
        # Draw transaxial
        print((img_i, ystart, xstart, img_max, np.max(np.multiply(np.divide(img_trans, img_max_0), 255))))
        data[ystart:ystart+img_y, xstart:xstart+img_x] = np.multiply(np.divide(img_trans, img_max_0), 255)
        img_mask[img_mask > 0] = 1
        mask[ystart:ystart+img_y, xstart:xstart+img_x] = img_mask
        if (img_i+1) % 5 == 0:
            xstart = 0
            ystart = ystart + img_y
        else:
            xstart = xstart + img_x

    img = PIL.Image.fromarray(data)
    img = img.convert('RGB')
    imgmask = PIL.Image.fromarray(mask)
    imgmask = imgmask.convert('RGB')
    d = img.getdata()
    dm = imgmask.getdata()
    
    new_image = []
    for i in range(len(d)):
        item = d[i]
        mitem = dm[i]
        if mitem[0] == 0 and mitem[1] == 0 and mitem[2] == 0:
            r = item[0]
            g = item[1]
            b = item[2]
        else:
            # add overlay
            r = int(item[0]*(1-alpha)+mitem[0]*alpha)
            g = int(item[1]*(1-alpha)+mitem[1]*alpha)
            g = item[1]
            b = int(item[2]*(1-alpha)+mitem[2]*alpha)
            b = item[2]
        new_image.append((r, g, b))
    # update image data
    img.putdata(new_image)

    #font = ImageFont.truetype("./Tahoma.ttf",22)
    #draw = ImageDraw.Draw(img)
    # for img_i in range(len(imagedatas)):
    #draw.text((10, ystart+10), "ADC", (255,255,0), font=font)
    #ystart = ystart + img_y
    img.save(filename)


def load_nifti(name, filename):
    """
        Loads Nifti data
        :param name: data name for stdout
        :param filename: loaded filename
        :return: data matrix, affine transformation matrix, data voxelsize
        """
    img = nib.load(filename)
    img = nib.Nifti1Image(img.get_fdata(), np.eye(4))
    try:
        affine = img.affine
    except:
        affine = img.get_affine()
    try:
        data_sform = img.get_sform()
    except:
        data_sform = img.get_header().get_sform()
    try:
        data_qform = img.get_sform()
    except:
        data_qform = img.get_header().get_qform()
    data = img.get_fdata()
    voxelsize = [abs(data_sform[0, 0]), abs(data_sform[1, 1]), abs(data_sform[2,2])]
    print('Loading ' + name + ':' + filename + ' ' + str(data.shape) + ' ' + str(voxelsize))

    return np.squeeze(data), affine, voxelsize


###############
# MAIN SCRIPT #
###############
if __name__ == "__main__":
    # Parse input arguments into args structure
    parser = ArgumentParser()
    parser.add_argument("--bgfile", dest="bgfile", help="modality", default="PM.nii", required=False)
    parser.add_argument("--maskname", dest="maskname", help="modality", default="PM.nii", required=False)
    parser.add_argument("--oname", dest="oname", help="output", required=True)
    parser.add_argument("--offset", dest="offset", help="offset", required=False, default='70')
    parser.add_argument("--scale", dest="scale", help="scale", required=False, default='2')
    parser.add_argument("--flip", dest="flip", help="flip", required=False, default='None')
    args = parser.parse_args()
    bgfile = args.bgfile
    maskname = args.maskname
    oname = args.oname
    offset = int(float(args.offset))
    scale = int(float(args.scale))
    write_QC_scales_maskfusion(bgfile, maskname, oname, [scale], offset, 0.5, args.flip)
