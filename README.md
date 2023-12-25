# Preprocessing for ZephIR

This README provides instructions on how to use the preprocessing code to transform and reorganize data for use with ZephIR, a software tool designed for tracking neurons in freely behaving and deformable brains.

## Prerequisites

Before you begin, ensure that your dataset includes the following:
- Green fluorescence imaging data
- Red fluorescence imaging data
- Worm centerline data

These data are essential for the successful application of the preprocessing steps.

## Step-by-Step Guide

### Step 1: Set Up Your Data Directory

Locate the `load_data.m` MATLAB file under the `scripts` directory. You will need to modify this file to specify the location of your dataset.

- Open `load_data.m` in MATLAB or a text editor.
- Change the `data_directory` variable to the path where your dataset is stored.
- Update the `filenames` variable to match the names of your data files.

### Step 2: Decide on Image Binning

Consider whether you want to bin your raw images. Binning can reduce the resolution of your images but may significantly speed up the processing time in ZephIR.

- If you choose to bin your images, ensure that the binning process is incorporated into your preprocessing steps.

### Step 3: Run Preprocessing Scripts

With your data directory and filenames set, and your decision on binning made, run the preprocessing scripts in MATLAB:

```matlab
cd scripts
load_data;
transform_and_reorganize_imagedata;
```

`load_data` will load your specified dataset. `transform_and_reorganize_imagedata` will apply necessary transformations and reorganize the data for ZephIR compatibility.

### Step 4: Access the Processed Data

After running the scripts, the reorganized data will be saved in the same folder as `data.mat`. This file is now ready to be used with ZephIR for neuron tracking analysis.

