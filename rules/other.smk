# An example collection of Snakemake rules imported in the main Snakefile.
import os

filepaths=dict()
if os.path.exists("index"):
    import json
    filepaths = json.load(open("index",'r'))

def generate_output_name(input_name,output_dir):
    x= os.path.join(os.path.dirname(input_name), 
                        output_dir,
		        os.path.basename(input_name))
    print(x)
    import sys
    sys.exit(1)
    return x

rule combined_wrfout:
    input:
        index="index",
        files=expand("output/{filename}.{{diag}}",filename=filepaths.get("wrfout",[]))
    output:
        "final/wrfout.{diag}.nc"
    shell:
        """
        ncrcat {input.files} -o final/wrfout.{wildcards.diag}.nc
        """

rule all_ls:
    input:
        index="index",
        files=expand("output/{filename}.ls",filename=filepaths.get("wrfout",[]))
   
rule all_t15:
    input:
        index="index",
        files=expand("output/{filename}.t15",filename=filepaths.get("wrfout",[]))

rule all_ice:
    input:
        index="index",
        files=expand("output/{filename}.icemass",filename=filepaths.get("wrfout",[]))


rule diag_simple:
    input:
        "{filename}"
    output:
         "output/{filename}.{diag}"
    shell:
        "pydwrf2 {wildcards.diag} {input} {output}"   

# make the index file in the parent directory
rule make_index:
    output:
        "index"
    shell:
        "pydwrf2 index ./ {output}"
