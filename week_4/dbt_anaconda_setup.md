 ### Install dbt in Anaconda      

From the official [dbt docs](https://docs.getdbt.com/dbt-cli/install/pip):

> You can install dbt Core and plugins using pip because they are Python modules distributed on PyPi. We recommend using virtual environments when installing with pip

### How to do it if we are using Anaconda environments?  

#### Method 1: using `conda`     

When using Anaconda envs it's advised to install packages through the `conda` package manager. It seems `dbt-bigquery` is available for Anaconda, see [here](https://anaconda.org/conda-forge/dbt-bigquery).   

`conda install -c conda-forge dbt-bigquery`   

This method didn't work for me because the conda package manager could not resolve dependencies (I'm running Linux Mint). Other times the packages are not available for `conda` and we have to use `pip`    

#### Method 2: using `pip`     

The trick here is to install `pip` in our Anaconda environment **and then use that installation** to run the `pip install <package-name>` command. More details [here](https://stackoverflow.com/questions/41060382/using-pip-to-install-packages-to-anaconda-environment
).  

1) Activate the Anaconda env created for this course  
`conda activate <env-name>`   

2) Install pip   
`conda install pip`  

3) Look for the installation of pip in your system by running `which pip` in your terminal.  
For me it looks like this: `/home/jm/anaconda3/envs/de/bin/pip`. This is the path where we've just installed pip (here `jm` is my user and `de` is the name of my env)    


4) Install dbt-bigquery by running the following command  
`/home/jm/anaconda3/envs/de/bin/pip install dbt-bigquery`

NOTE: As per dbt docs, all adapters build on top of `dbt-core`. There's no need to install `dbt-core` before `dbt-bigquery`  
