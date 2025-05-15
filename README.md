# nf-kpnrna
Nextflow pipeline for Kpn RNA-seq


# Usage

```bash
./nextflow run -r main BioinfoSupport/nf-kpnrna -profile hpc -resume
```

## Docker 
```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):$(pwd) \
  --platform linux/amd64 \
  --workdir $(pwd) \
  --env NXF_HOME=$(pwd)/.nextflow_home \
  nextflow/nextflow:24.10.4 bash
```

```bash
nextflow run . -resume
```


# TODO
 - Add read trimming step to uniformize lengths
 - Change the pipeline to take as input one genome folder, and run it for each genome
 - Create a pipeline to prepare genomes ?
 
 