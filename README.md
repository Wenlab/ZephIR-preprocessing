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

Consider whether you want to bin your raw images. Binning can reduce the resolution of your images but may significantly speed up the processing time in ZephIR. Also note that ZephIR only supports `uint8` right now.

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

## Running ZephIR on the Computational Server

To run ZephIR on the computational server, follow these steps:

### Step 5: Navigate to the Data Directory

First, navigate to the `data_directory` where your preprocessed data is stored.

```bash
cd path/to/data_directory
```
Replace path/to/data_directory with the actual path to your data directory. Copy `getters.py` and `metadata.json` to the `data_directory` as well. Modify `metadata.json` if the image stack size is different.

### Step 6: Activate ZephIR Environment
Activate the ZephIR Conda environment by running:

```bash
conda activate ZephIR
```

### Step 7: Follow ZephIR Instructions

Next, follow the detailed instructions provided in the ZephIR guide. These instructions are available at the following URL:

[ZephIR Guide](https://github.com/venkatachalamlab/ZephIR/blob/main/docs/Guide-ZephIR.md)

Here are three major steps. 

- Find a few (specified by `--n_frames`) reference frames where we first perform manual annotaions. 

```bash
recommend_frames --dataset=. --n_frames=10
```
ZephIR would identify the similarity between different imaging frames and recommend `n_frames` root frames. 

- Run the following script to open the annotation GUI.  Perform manual annotation on the reference frames and save the results.

```bash
annotator --dataset=. --port=5001
```
- Close the annoation GUI. Now perform machine tracking of the rest frames. Copy `args.json` to the dataset folder. This file contains tuning parameters that I find work well for sparsely labelled neurons in crawling worms. Now run

```bash
zephir --dataset=. --load_args=True
```
- Reopen the annotation GUI to check and proofread the results. 


### Step 8: Port Forwarding for Annotation GUI
Ensure that you forward port 5000 to your local computer when using Visual Studio Code (VSCode). This setup allows you to access the annotation GUI at localhost:5000.

If port 5000 is not available or does not work, try using a different port number, such as 5001. Adjust your port forwarding settings accordingly.

### Step 9: identify the coordinates of annotated points in the original image stacks
Once you finish tracking all the neurons and saving your results in the `annotations.h5` using ZephIR, you can run the following scripts to find (in `annotations_edited.h5`) the normalized coordinates of these neurons in the original image stacks. 

```matlab
cd scripts
annotations
```
The new `annotations_edited.h5` should now contain the following and more:
- t_idx: time index of each annotation, starting from 0
- x: x-coordinate as a float between (0, 1)
- y: y-coordinate as a float between (0, 1)
- z: z-coordinate as a float between (0, 1)
- x_original: x-coordinate as a float between (0, 1) in the original image stacks
- y_original: y-coordinate as a float between (0, 1) in the original image stacks
- worldline_id: track or worldline ID as an integer



