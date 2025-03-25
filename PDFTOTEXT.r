# PDF-to-Text OCR Script (Simplified)
# Author: Mick Morrison

# Install required packages
if (!requireNamespace("pdftools", quietly = TRUE)) install.packages("pdftools")
if (!requireNamespace("tesseract", quietly = TRUE)) install.packages("tesseract")

# Load libraries
library(pdftools)
library(tesseract)

# ----------- USER CONFIGURATION -----------

input_dir <- "~/ownCloud - UNE/Teaching/HINQ302 Researching the Past in the Digital Age/content/Topic 05 Archival and Documentary Research 2/Example_Corpus/"         # Folder with scanned PDFs
output_dir <- "~/ownCloud - UNE/Teaching/HINQ302 Researching the Past in the Digital Age/content/Topic 05 Archival and Documentary Research 2/Example_Corpus/text"             # Folder for output .txt files

# ----------- DO NOT EDIT BELOW -----------

input_dir <- path.expand(input_dir)
output_dir <- path.expand(output_dir)

if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
if (!dir.exists(output_dir)) stop("Failed to create: ", output_dir)

pdf_files <- list.files(input_dir, pattern = "\\.pdf$", full.names = TRUE)

if (length(pdf_files) == 0) {
  message("No PDF files found in: ", input_dir)
} else {
  message("Found ", length(pdf_files), " PDF file(s):")
  print(basename(pdf_files))
}

for (pdf_file in pdf_files) {
  message("Processing: ", pdf_file)
  tryCatch({
    text_pages <- pdf_ocr_text(pdf_file)
    full_text <- paste(text_pages, collapse = "\n")
    output_file <- file.path(output_dir, paste0(tools::file_path_sans_ext(basename(pdf_file)), ".txt"))
    writeLines(full_text, con = output_file)
    message("Saved to: ", output_file)
  }, error = function(e) {
    message("Error with ", pdf_file, ": ", e$message)
  })
}
