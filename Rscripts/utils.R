library(tidyverse)
library(data.table)
library(scales)
library(ggforce)
library(cowplot)
library(dplyr)
library(splitstackshape)
library(ggridges)
library(IRanges)
library(ggrepel)
library(ggnewscale)
library(ggside)
library(glue)
library("tidylog", warn.conflicts = FALSE)
library(patchwork)

Red="#c1272d"
Indigo="#0000a7"
Yellow="#eecc16"
Teal="#008176"
Gray="#b3b3b3"

MODEL_COLORS = c(PacBio=Indigo, 
    CNN=Red,  
    XGB=Yellow,
    GMM=Teal,
    IPD=Gray,
    SEMI="purple",
    Revio="#f41c90" # black
)

read_m6a = function(file, my_tag = "", min_ml = 200, nrows=Inf, ref=TRUE){
    tmp = fread(glue(file), nrows=nrows)  %>%
        filter(en - st > 0.5 * fiber_length | (en == 0 & st == 0)) %>%
        filter(ec > 3.9)
        #[tmp$fiber %in% sample(unique(tmp$fiber), 500)] 
    tmp = tmp %>% 
        mutate(
            fake_end = dplyr::case_when(
                en == 0 ~ 11,
                TRUE ~ as.numeric(en)
            ),
            st=as.numeric(st),
            index = row_number(),
            bin = IRanges::disjointBins(
                IRanges(st+1, fake_end) + 150 #+ (fake_end - st+1) / 10
            ),
        )
    if(ref){
        m6a = tmp %>%
            select(ref_m6a, fiber, fiber_length, m6a_qual, bin, st, en, strand) %>%
            filter(ref_m6a!=".") %>%
            cSplit(c("m6a_qual", "ref_m6a"), direction = "long") %>%
            filter(m6a_qual > min_ml) %>%
            mutate(
                type = "m6A",
                start = ref_m6a,
                end = ref_m6a + 1,
                alpha = 1.0,
                size = 2,
            )

        nuc = tmp %>%
            select(fiber, fiber_length, ref_nuc_starts, ref_nuc_lengths, bin, st, en, strand) %>%
            filter(ref_nuc_starts!=".") %>%
            cSplit(c("ref_nuc_starts", "ref_nuc_lengths"), direction = "long") %>%
            mutate(
                type = "Nucleosome",
                start = ref_nuc_starts,
                end = ref_nuc_starts + ref_nuc_lengths,
                alpha = 0.8,
                size = 1,
            )

        msp = tmp %>%
            select(fiber, fiber_length, ref_msp_starts, ref_msp_lengths, bin, st, en, strand) %>%
            filter(ref_msp_starts!=".") %>%
            cSplit(c("ref_msp_starts", "ref_msp_lengths"), direction = "long") %>%
            mutate(
                type = "MSP",
                start = ref_msp_starts,
                end = ref_msp_starts + ref_msp_lengths,
                alpha = 0.8,
                size = 1,
            )
    } else {
        m6a = tmp %>%
            select(m6a, fiber, fiber_length, m6a_qual, bin, st, en, strand) %>%
            filter(m6a!=".") %>%
            cSplit(c("m6a_qual", "m6a"), direction = "long") %>%
            filter(m6a_qual > min_ml) %>%
            mutate(
                type = "m6A",
                start = m6a,
                end = m6a + 1,
                alpha = 1.0,
                size = 2,
            )

        nuc = tmp %>%
            select(fiber, fiber_length, nuc_starts, nuc_lengths, bin, st, en, strand) %>%
            filter(nuc_starts!=".") %>%
            cSplit(c("nuc_starts", "nuc_lengths"), direction = "long") %>%
            mutate(
                type = "Nucleosome",
                start = nuc_starts,
                end = nuc_starts + nuc_lengths,
                alpha = 0.8,
                size = 1,
            ) 
        
        msp = tmp %>%
            select(fiber, fiber_length, msp_starts, msp_lengths, bin, st, en, strand) %>%
            filter(msp_starts!=".") %>%
            cSplit(c("msp_starts", "msp_lengths"), direction = "long") %>%
            mutate(
                type = "MSP",
                start = msp_starts,
                end = msp_starts + msp_lengths,
                alpha = 0.8,
                size = 1,
            )
    }

    print(my_tag)
    print(dim(tmp))
    print(dim(m6a))
    bind_rows(list(nuc, m6a, msp)) %>%
        mutate(tag = my_tag) %>%
        filter(start != -1) %>%
        group_by(type, fiber) %>%
        arrange(start) %>%
        mutate(
            dist = start - lag(start)
        ) %>%
        data.table()
}


get_maxima_from_plot = function(p, n_keep=3 ){
    dens <- layer_data(p, 1)
    dens <- dens %>% arrange(colour, fill, x)

    # Run length encode the sign of difference
    rle <- rle(diff(as.vector(dens$y)) > 0)
    # Calculate startpoints of runs
    starts <- cumsum(rle$lengths) - rle$lengths + 1
    # Take the points where the rle is FALSE (so difference goes from positive to negative) 
    maxima_id <- starts[!rle$values]
    maxima <- dens[maxima_id,]
    maxima %>% group_by(colour, fill) %>% slice_max(order_by = y, n = n_keep)
}


my_ggsave <- function(file, ...){
    file = glue(file)
    print(file)
    ggsave("tmp.pdf", ...)
    cmd = glue("cp tmp.pdf {file}")
    print(cmd)
    system(cmd)
}
