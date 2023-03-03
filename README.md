# Deuel

Named for Deuel Creek

It's a great, short hike that even doggos can join.

The scripts and ideas from [GAS_Scripts_Reference](https://github.com/BenJamesMetcalf/GAS_Scripts_Reference) were needed for Group A Streptococcus typing, but these scripts were built for an environment that was not easily sharable. 

## Dependencies
- nextflow version X+
- singularity or docker

That's it!

## Usage

### Option 1: Having paired-end fastq files in a directory

```bash
nextflow run UPHL-BioNGS/Deuel --reads <directory to reads>
```

### Option 2: Using a sample sheet

The sample sheet format is as follows:
```
sample,fastq_1,fastq_2
```

The sample sheet is then used as input for Deuel with the following command
```bash
nextflow run UPHL-BioNGS/Deuel --sample_sheet <sample_sheet>
```

## Using a custom config file

Deuel doesn't have a lot of paramters that can be adjusted because it is a nextflow version of [GAS_Scripts_Reference](https://github.com/BenJamesMetcalf/GAS_Scripts_Reference). Still, a copy of a template of adjustable parameters that may be useful by setting the `config` parameter. This will copy a template file named `editme.config` in the users current directory.

```bash
nextflow run UPHL-BioNGS/Deuel --config true
```

## Parameters and their default values
```
# setting params.test = true will run the workflow with some include test paired-end fastq files
params.test = false
# adjusting params.outdir will change where the files are saved
params.outdir = 'deuel'
# set location of sample sheet 
params.sample_sheet = ''
# set location of directory with paired-end reads
params.reads = ''
```

## Frequently asked questions