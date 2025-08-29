# Sorting Algorithms in ARM Assembly

This repository contains implementations of sorting algorithms written in ARM Assembly.

## Algorithms Implemented

### 1. Bubble Sort
- Repeatedly compares adjacent elements.
- Swaps them if they are in the wrong order.
- Largest element "bubbles up" to the end in each pass.

### 2. Insertion Sort
- Builds the sorted array one element at a time.
- Picks an element and inserts it into its correct position among the already sorted part.

### 3. Selection Sort
- Repeatedly finds the smallest element from the unsorted part.
- Places it at the beginning of the unsorted section.
- Array gets sorted from left to right.

### 4. Merge Sort
- Divide-and-conquer algorithm.
- Splits the array into halves until single elements remain.
- Merges them back together in sorted order.

### 5. Quick Sort
- Selects a pivot element.
- Partitions the array so that elements smaller than pivot go left, greater go right.
- Recursively sorts the partitions.

### 6. Radix Sort
- Non-comparative sorting algorithm.
- Processes integers digit by digit (e.g., from least significant digit to most).
- Uses counting sort (or similar) as a subroutine for each digit.
