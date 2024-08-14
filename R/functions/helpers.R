#==============================================================================#
# Translations ####
#==============================================================================#

trslt_repo_type <- function(str) {
  
  case_when(
    str_starts(str, "Link to p") ~
      switch(
        params$lang,
        en = "Link to paper/supplementary material",
        de = "Link auf Artikel/zusätzliche Unterlagen",
        fr = "Lien vers l’article/matériel complémentaire"
      ),
    str_detect(str, "\\(FAIR\\)") ~
      switch(
        params$lang,
        en = "Repository (FAIR)",
        de = "Archiv (FAIR)",
        fr = "Dépôt de données (FAIR)"
      ),
    str_detect(str, "\\(not FAIR\\)") ~
      switch(
        params$lang,
        en = "Repository (not FAIR)",
        de = "Archiv (nicht FAIR)",
        fr = "Dépôt de données (non FAIR)"
      ),
    str_detect(str, "Other") ~
      switch(
        params$lang,
        en = "Other",
        de = "Andere",
        fr = "Autre"
      ),
    str_starts(str, "Link not") ~
      switch(
        params$lang,
        en = "Link not available",
        de = "Link nicht verfügbar",
        fr = "Lien non disponible"
      )
  )
  
}

#==============================================================================#
# Make figures ####
#==============================================================================#

make_fig_1 <- function() {
  
  n_datasets_per_year |>
    mutate(data_id = row_number()) |>
    ggplot() +
    aes(
      x = grant_end_year,
      y = prop_proj_with_one_ds,
      color = research_area,
      group = research_area
    ) +
    geom_line(linewidth = 0.75) +
    geom_point_interactive(
      aes(
        tooltip =
          paste0(
            switch(params$lang, en = "Year: ", de = "Jahr: ", fr = "Année : "),
            grant_end_year, "<br>",
            switch(
              params$lang,
              en = "Research area: ",
              de = "Forschungsbereich: ",
              fr = "Domaine de recherche : "
            ),
            research_area, "<br>",
            switch(
              params$lang,
              en = "Number of completed projects: ",
              de = "Anzahl abgeschlossener Projekte: ",
              fr = "Nombre de projets complétés : "
            ),
            round(n_proj),
            " (", round(n_proj_with_ds),
            switch(
              params$lang,
              en = " with at least 1 dataset)",
              de = " mit mindestens einem Datensatz)",
              fr = " avec au moins 1 set de données)"
            ),
            "<br>",
            switch(
              params$lang,
              en = "Number of declared datasets: ",
              de = "Anzahl gemeldeter Datensätze: ",
              fr = "Nombre de sets de données déclarés : "
            ),
            round(n_ds)
          ),
        data_id = data_id
      ),
      size = 1.75
    ) +
    scale_y_continuous(labels = scales::percent) +
    scale_color_manual(values = c(get_datastory_scheme()[1:3], "#4F4F4F")) +
    get_datastory_theme()
  
}

make_fig_2 <- function() {
  
  outputdata_and_meta |>
    select(
      grant_number,
      fair_data_repository,
      grant_end_year,
      repository_name,
      repo_type
    ) |>
    mutate(repo_type = trslt_repo_type(repo_type)) |>
    left_join(
      area_recoding,
      by = join_by(grant_number == ApplicationNumber)
    ) |>
    pivot_longer(is_SSH:is_LS, names_to = "research_area", values_to = "area_prop") |>
    filter(area_prop != 0) |>
    summarise(
      n = sum(area_prop),
      .by = c(research_area, grant_end_year, repo_type)
    ) |>
    mutate(
      repo_type =
        fct_rev(
          fct_relevel(
            repo_type,
            trslt_repo_type("Repository (FAIR)"),
            trslt_repo_type("Repository (not FAIR)"),
            trslt_repo_type("Link to paper/supplementary material"),
            trslt_repo_type("Link not available"),
            trslt_repo_type("Other")
          )
        ),
      research_area =
        fct(
          translate_research_area(str_remove(research_area, "is_"), params$lang, "abbr"),
          levels =
            c(
              translate_research_area(c("SSH", "MINT", "LS"), params$lang, "abbr"),
              "UNKNOWN"
            )
        ) |>
        fct_relabel(
          \(x)
          if_else(
            x == "UNKNOWN",
            switch(params$lang, en = "All", de = "", fr = "Tous"),
            x
          )
        )
    ) |>
    mutate(
      prop = n / sum(n),
      label = if_else(repo_type == trslt_repo_type("Repository (FAIR)"), paste0("n = ", n), NA),
      label_y_pos = if_else(repo_type == trslt_repo_type("Repository (FAIR)"), prop / 2, NA),
      .by = c(research_area, grant_end_year)
    ) |>
    mutate(data_id = row_number()) |>
    ggplot() +
    aes(x = prop, y = grant_end_year, fill = repo_type, group = repo_type) +
    geom_col_interactive(
      aes(
        tooltip =
          paste0(
            switch(params$lang, en = "Year: ", de = "Jahr: ", fr = "Année : "),
            grant_end_year, "<br>",
            switch(
              params$lang,
              en = "Research area: ",
              de = "Forschungsbereich: ",
              fr = "Domaine de recherche : "
            ),
            research_area, "<br>",
            switch(
              params$lang,
              en = "Type: ",
              de = "Typ: ",
              fr = "Type : "
            ),
            repo_type, "<br>",
            switch(
              params$lang,
              en = "Share: ",
              de = "Anteil: ",
              fr = "Part : "
            ), round(prop * 100), "%"
          ),
        data_id = data_id
      ),
      width = 0.7
    ) +
    scale_x_continuous(labels = scales::percent) +
    scale_fill_manual(
      values = rev(get_datastory_scheme()[1:6][-4]),
      guide = guide_legend(byrow = TRUE, reverse = TRUE, nrow = 2)
    ) +
    facet_wrap(~research_area, ncol = 2) +
    get_datastory_theme(legend_position = "top", family = font) +
    theme(
      axis.text.x =  element_text(size = 9),
      axis.text.y =  element_text(size = 9)
    )
  
}

make_fig_3 <- function(text_size = 3) {
  
  repo_all_formatted |>
    mutate(data_id = row_number()) |>
    ggplot() +
    aes(x = as.numeric(grant_end_year), y = rank, color = repository_name) +
    ggbump::geom_bump(
      aes(linetype = is_fair),
      linewidth = 0.75,
      show.legend = FALSE
    ) +
    geom_point_interactive(
      aes(
        tooltip =
          paste0(
            switch(
              params$lang,
              en = "Period: ",
              de = "Zeitraum: ",
              fr = "Période : "
            ),
            grant_end_year, "<br>",
            switch(
              params$lang,
              en = "Repository: ",
              de = "Datenarchiv: ",
              fr = "Dépôt : "
            ),
            repository_name, " (",
            switch(
              params$lang,
              en = is_fair,
              de = str_replace(is_fair, "not", "nicht"),
              fr = str_replace(is_fair, "not", "non")
            ),
            ")", "<br>",
            switch(
              params$lang,
              en = "Rank: ",
              de = "Rang: ",
              fr = "Rang : "
            ),
            rank, "<br>",
            switch(
              params$lang,
              en = "Number of deposited datasets: ",
              de = "Anzahl abgelegter Datensätze: ",
              fr = "Nombre de sets de données archivés : "
            ),
            n,
            switch(
              params$lang,
              en = " (out of ",
              de = " (von ",
              fr = " (sur "
            ),
            N, ")"
          ),
        data_id = data_id
      ),
      size = 1.75,
      show.legend = FALSE
    ) +
    
    geom_text(
      data = filter(repo_all_formatted, grant_end_year == "2021/22"),
      aes(
        x = as.numeric(grant_end_year) + 0.05,
        y = rank,
        label = paste0(repository_name, " (N = ", n, "; ", round(prop * 100), "%)")
      ),
      hjust = 0,
      size = text_size,
      inherit.aes = FALSE,
      show.legend = FALSE
    ) +
    geom_text(
      data = filter(repo_all_formatted, grant_end_year == "2017/18"),
      aes(
        x = as.numeric(grant_end_year) - 0.05,
        y = rank,
        label = paste0(repository_name, " (N = ", n, "; ", round(prop * 100), "%)")
      ),
      hjust = 1,
      size = text_size,
      inherit.aes = FALSE,
      show.legend = FALSE
    ) +
    geom_text(
      data =
        repo_all_formatted |>
        filter(
          rank[grant_end_year == "2019/20"] <= 20
          & !any(rank[grant_end_year != "2019/20"] <= 20)
          & grant_end_year == "2019/20",
          .by = repository_name
        ),
      aes(
        x = as.numeric(grant_end_year),
        y = rank - 0.5,
        label = repository_name
      ),
      hjust = 0.5,
      size = text_size,
      inherit.aes = FALSE,
      show.legend = FALSE
    ) +
    scale_x_continuous(
      limits = c(-0.25,4.35),
      breaks = c(1, 2, 3),
      labels = c("2017/18", "2019/20", "2021/22")
    ) +
    scale_color_manual(values = get_datastory_scheme(n_col = 35)) +
    coord_cartesian(ylim = c(19.6, 1)) +
    get_datastory_theme(text_axis = "x", remove_plot_margin = TRUE)
  
}

#==============================================================================#
# Interactive plots ####
#==============================================================================#

make_ggiraph <- function(x,                    # ggplot object
                         height = 5,           # height of the svg generated
                         width = 6,            # height of the svg generated
                         sw = 2,               # width of the stroke
                         fcolor = "#ff0000",   # color (fill)
                         color = NA,           # color
                         scolor = "#ff0000") { # color of the stroke
  
  girafe(
    ggobj = x,
    height_svg = height,
    options = list(
      opts_toolbar(saveaspng = FALSE),
      opts_hover(
        css =
          glue("fill:{fcolor};color:{color};stroke:{scolor};stroke-width:{sw};")
      ),
      opts_tooltip(
        css = get_ggiraph_tooltip_css(family = "Theinhardt"),
        opacity = 0.8,
        delay_mouseover = 0,
        delay_mouseout = 0
      )
    )
  )
}
