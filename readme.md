# Datastory: *Open research data: a first look at sharing practices*

*Researchers funded by the SNSF are expected to share their datasets in public repositories. A first look shows that many researchers are not regularly reporting their datasets to the SNSF, but most of those provided follow FAIR principles.*

[English](https://data.snf.ch/stories/open-research-data-2023-en.html)\
[German](https://data.snf.ch/stories/open-research-data-2023-de.html)\
[French](https://data.snf.ch/stories/donnees-ouvertes-2023-fr.html)

**Author(s)**: Simon Gorin, Sylvia Jeney, Anne Jorstad, Lionel Perini, Martin von Arx

**Publication date**: 15.08.2024

## Data description

The data used in this data story are available in the folder `data`. The data consist of three files:

-   `data/data.csv` is from the "Output data: Datasets" available in the [Datasets section](https://data.snf.ch/datasets) of the SNSF Data Portal. We considered grants from all funding schemes (except Science Communication and Infrastructure) that ended between October 2017 and 2022. The data were collected mid-March 2023 and manually curated to check the FAIRness of the repository (see the [data story](https://data.snf.ch/stories/open-research-data-2023-en.html) for more details). The data contain the following fields:

    -   `id`: Unique identifier of the dataset (for the SNSF).
    -   `title`: Title of the dataset (mandatory field).
    -   `author`: Authors of the dataset, separated by semicolon (last name, first name; mandatory field).
    -   `doi`: The DOI of the dataset if available.
    -   `publication_date`: Date when the dataset was published.
    -   `repository_link`: Link to the repository, ideally a direct link to the dataset (mandatory field).
    -   `repository_name`: Name of the repository where the dataset is available (mandatory field).
    -   `repo_type`: Type of repository/link (manually curated).
    -   `fair_data_repository`: Whether the repository is FAIR or not (manually curated).
    -   `grant_number`: Unique identifier of the project to which the dataset is linked.
    -   `grant_end_date`: The date when the grant ended.
    -   `grant_end_year`: The year when the grant ended.
    -   `main_discipline_level1`: The SNSF Level 1 main discipline of the project to which the dataset is linked.
    -   `research_area_short`: Short name of `main_discipline_level1`.
    -   `is_open`: Whether the dataset is open (from DataCite).
    -   `is_cc`: Whether the dataset has a CC-BY license (from DataCite).
    -   `is_gpl`: Whether the dataset has a GNU General Public license (from DataCite).
    -   `is_odc`: Whether the dataset has a Open Data Common license (from DataCite).
    -   `is_mit`: Whether the dataset has a MIT license (from DataCite).
    -   `is_apache`: Whether the dataset has a Apache license (from DataCite).
    -   `is_public`: Whether the dataset is public (from DataCite).
    -   `is_bsd`: Whether the dataset has a Berkeley Software Distribution license (from DataCite).

-   `data/datasets_per_year.csv`: is from the "Output data: Datasets" available in the [Datasets section](https://data.snf.ch/datasets) of the SNSF Data Portal. We considered grants from all funding schemes (except Science Communication and Infrastructure) that ended between October 2017 and 2023. The data were last generated on 14.08.2024. The data contain the following fields:

    -   `Number`: Unique identifier of the project to which the dataset is linked (same as `grant_number` in `data.csv`).
    -   `EffectiveEndDate`:The date when the grant ended (same as `grant_end_date` in `data.csv`).
    -   `MainDisciplineLevel1`: The SNSF Level 1 main discipline of the project to which the dataset is linked (same as `main_discipline_level1`in `data.csv`).
    -   `CallTitle`: The title of the call.
    -   `OutputDataSetId`: Unique identifier of the dataset (for the SNSF) (same as `id` in `data.csv`). For grants without output dataset, this field is set as `NA`.

-   `data/area_recoding.csv` contains the weight to recode the research area of the grants included in the data story. Since the interdisciplinary category is not covered in the data story, these grants where reassigned to the other research area (SSH, MINT, and LS) based on the distribution of the disciplines listed in the grants. The data contain the following fields:

    -   `Number`: Unique identifier of the project to which the dataset is linked (same as `Number` in `datasets_per_year.csv`).
    -   `is_SSH`: Whether the grant's research area is SSH. For mono-disciplinary grants, the value is 1 (SSH) or 0 (not SSH). For interdisciplinary grants, the value represents the share of disciplines from the SSH research area listed in the application.
    -   `is_MINT`: Whether the grant's research area is MINT. For mono-disciplinary grants, the value is 1 (MINT) or 0 (not MINT). For interdisciplinary grants, the value represents the share of disciplines from the MINT research area listed in the application.
    -   `is_LS`: Whether the grant's research area is LS. For mono-disciplinary grants, the value is 1 (LS) or 0 (not LS). For interdisciplinary grants, the value represents the share of disciplines from the LS research area listed in the application.

In case of any questions, please contact: [datastories\@snf.ch](mailto:datastories@snf.ch){.email}.
