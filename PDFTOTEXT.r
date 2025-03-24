## PDFTOTEXT Extraction Tool for RStudio
## Author: Mick Morrison
## Description:
## This script processes a folder of scanned PDF documents using OCR (via 'pdftools' and 'tesseract') 
## to extract text and save it as plain text files. It is designed for use in cross-platform R environments 
## (macOS, Windows, Linux).

## ===========================
## INSTRUCTIONS FOR STUDENTS:
##
## 1. Set your input_dir and output_dir to valid folders on *your* computer.
##    Replace the sample paths below with your own. Use full paths.
##    Example (Windows): "C:/Users/YourName/Documents/my_pdfs"
##    Example (macOS):   "/Users/yourname/Documents/my_pdfs"
##
## 2. Make sure the PDFs are image-based (scanned), not digitally encoded PDFs.
##
## 3. Run the entire script in RStudio. The output will be a set of .txt files 
##    saved in the output_dir, with OCR-extracted text from the PDFs.
##
## ===========================

# Install required packages if not already installed
if (!requireNamespace("pdftools", quietly = TRUE)) {
  install.packages("pdftools")  # PDF reading and OCR interface
}
if (!requireNamespace("tesseract", quietly = TRUE)) {
  install.packages("tesseract")  # OCR engine
}

# Load libraries
library(pdftools)
library(tesseract)

# ----------- USER CONFIGURATION REQUIRED BELOW -----------

# Set path to folder with scanned PDF files (edit this!)
input_dir <- "~/ownCloud - UNE/Teaching/HINQ302 Researching the Past in the Digital Age/content/Topic 05 Archival and Documentary Research 2/Example_Corpus/higherresexample/originals/"   
setwd(input_dir)
# Set path to folder where output .txt files will be saved (edit this!)
output_dir <- "~/output"

# ----------- END OF USER CONFIGURATION -----------

# Cross-platform compatibility: convert ~ to full path if needed
input_dir <- path.expand(input_dir)
output_dir <- path.expand(output_dir)

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# List all PDF files in the input directory
pdf_files <- list.files(input_dir, pattern = "\\.pdf$", full.names = TRUE)

# Display the list of files found
if (length(pdf_files) == 0) {
  message("No PDF files found in the input directory: ", input_dir)
} else {
  message("Found ", length(pdf_files), " PDF file(s):")
  for (i in seq_along(pdf_files)) {
    message(sprintf("  [%02d] %s", i, basename(pdf_files[i])))
  }
}
print(pdf_files)
# Loop over each file and extract OCR text
for (pdf_file in pdf_files) {
  message("Processing: ", pdf_file)
  
  # Use OCR to extract text from each page
  text_pages <- pdf_ocr_text(pdf_file)
  
  # Combine all pages into one string
  full_text <- paste(text_pages, collapse = "\n")
  
  # Define output filename
  output_file <- file.path(output_dir, paste0(tools::file_path_sans_ext(basename(pdf_file)), ".txt"))
  
  # Save extracted text to file
  writeLines(full_text, con = output_file)
  
  message("Saved OCR text to: ", output_file)
}
