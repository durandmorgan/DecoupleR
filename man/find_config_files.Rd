% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_config.R
\name{find_config_files}
\alias{find_config_files}
\title{Config file search}
\usage{
find_config_files(path)
}
\arguments{
\item{path}{The directory from which the config file search is initialized.
Look in current and root directories until finding a config file reaching
the primary root.}
}
\value{
the full path of the config file found. If no config file are found,
 it returns a `NULL`.
}
\description{
Config file search
}
