# RTI beyond relighting: Image analysis for archaeological Oseberg textiles

![LIM2025](LIMlogo.png)

Reflectance Transformation Imaging (RTI), a non-destructive imaging technique, captures data rich in geometric and appearance information. However, it has traditionally been limited to relighting. We demonstrate RTI's expanded potential through analysis of the Oseberg textiles, degraded and fragmented archaeological artifacts that present analysis challenges under conventional imaging methods. We present feature maps by applying statistical and geometric analysis to RTI data and a visualization tool. The computational analysis of RTI data can reveal textile characteristics that remain obscured under traditional photography. 

This repository contains code and supplementary material for the conference paper "RTI beyond relighting: Image analysis for archaeological Oseberg textiles" presented at London Imaging Meeting 2025.



## Dataset
 The Oseberg textile collection contains many fragments, out of which some are highly degraded, without discernible motifs. Therefore, to demonstrate the effectiveness of RTI in textile analyses as a proof of concept, we picked a fragment named 1D (TexRec naming criteria) that still enables us to discern patterns and motifs to a certain extent. The dataset of 50 images (JPEG format, 6240 × 4160) was captured using RTI dome and  Fujifilm X-T4 digital camera.

 ![Dataset](V1D_50_compressed.jpg)

## Statistical  and Geometric Analysis
The theory and necessary background of statistical and geometric feature maps are explained in the supplementary material pdf in this repository. The statistical and geometric analysis is pixel-based.

## Classification of reflectance response
The illumination variation data is classified according to their similar signal and are clustered together. This algorithm uses Self Organizing Map (SOM) neural networks. Self-Organizing Maps (SOMs) are unsupervised neural networks that transform complex, high-dimensional data into simplified, grid-based representations while preserving the topological relationships between input patterns.

## Visualization Tool / Application
The code can be compiled into a GUI and used in museums or by non-technical professionals in the cultural heritage field.
