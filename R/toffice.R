##' @title export graph to MS office
##' @name toffice
##' @importFrom officer read_docx
##' @importFrom officer read_pptx
##' @importFrom officer read_xlsx
##' @importFrom magrittr %>%
##' @importFrom officer add_slide ph_with ph_location
##' @importFrom officer ph_location_type
##' @importFrom officer body_add_par
##' @importFrom rvg dml
##' @importFrom rvg body_add_vg
##' @importFrom rvg xl_add_vg
##' @importFrom grDevices recordPlot
##' @importFrom grDevices dev.cur hcl
##' @param figure plot figure function
##' @param format file format
##' @param filename output filename
##' @param title title for the figure
##' @param append append or not
##' @param width width of the output figure
##' @param height height of the output figure
##' @param devsize Boolean value show use device size or not (default = FALSE)
##' @param units the units in which to return the value – inches, cm, or pixels (device units)
##' @examples
##' if(interactive()){
##' plot(mtcars$mpg, mtcars$disp)
##' toffice(filename = file.path(tempdir(), "mtcars.pptx"), format = "pptx")
##' ## use ggplot2
##' ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
##' toffice(filename = file.path(tempdir(), "mtcars.pptx"),format = "pptx")
##' }
##' @author Kai Guo
##' @export
toffice <- function(figure = NULL, format = "pptx", filename= "temp.pptx",
                    title="",
                    append = FALSE, width = 4, height = 4, devsize = FALSE,
                    units = "in"){
    format = tolower(format)
    if (format == "ppt" | format == "pptx") {
        format = "ppt"
    }
    if (format == "doc" | format == "docx") {
        format = "doc"
    }
    if (format == "xls" | format == "xlsx"){
        format = "xls"
    }
    if(is.null(figure)){
        if (dev.cur() == 1)
            stop("No graphics device found")
        p <- recordPlot()
    }else{
        if(is.function(figure)){
            p <- figure()
        }else{
            p <- figure
        }
    }
    if(isTRUE(devsize)){
        width = dev.size(units)[1]
        height = dev.size(units)[2]
    }
    if(format == "ppt"){
        if(isTRUE(append)){
            if(file.exists(filename)){
                doc <- read_pptx(filename)
            }else{
                doc <- read_pptx()
                doc <- add_slide(doc, layout = "Title and Content", master = "Office Theme")
                print(doc, target=filename)
            }
        }else{
            doc <- read_pptx()
        }
        doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
        doc <- ph_with(doc, value = title, location = ph_location_type(type = "title"))
        doc <- ph_with(doc, dml(code = print(p)), location = ph_location(width = width, height = height))
        print(doc,target=filename)
    }
    if(format == "doc"){
        if(isTRUE(append)){
            if(file.exists(filename)){
                doc <- read_docx(filename)
            }else{
                doc <- read_docx()
                print(doc,target=filename)
            }
        }else{
            doc <- read_docx()
        }
        doc <- body_add_par(doc, value = title, style = "Normal" )
        doc <- body_add_vg(doc, print(p), width = width, height = height)
        print(doc, target = filename)
    }
    if(format == "xls"){
        doc <- read_xlsx()
        if(title == ""){
            title = "Feuil1"
        }
        doc <- xl_add_vg(doc, sheet = title, code = print(p), width = width, height = height, left=1, top=1)
        print(doc, target = filename)
    }
}

##' export figure to pptx
##' @name topptx
##' @param figure plot figure function
##' @param filename output filename
##' @param title title for the figure
##' @param width width of the output figure
##' @param height height of the output figure
##' @param append append or not
##' @param devsize Boolean value show use device size or not (default = FALSE)
##' @param units the units in which to return the value – inches, cm, or pixels (device units)
##' @examples
##' if(interactive()){
##' plot(mtcars$mpg, mtcars$disp)
##' topptx(filename = file.path(tempdir(), "mtcars.pptx"))
##' ## use ggplot2
##' ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
##' topptx(filename = file.path(tempdir(), "mtcars.pptx"))
##' }
##' @author Kai Guo
##' @export
topptx <- function(figure = NULL, filename = NULL, title = "", width = 6, height = 6,
        append = FALSE, devsize = FALSE, units = "in"){
    toffice(figure = figure, filename = filename, format = "pptx", title = title,
            width = width, height = height, append = append, devsize = devsize,
            units = units)
}
##' export figure to docx
##' @name todocx
##' @param figure plot figure function
##' @param filename output filename
##' @param title title for the figure
##' @param width width of the output figure
##' @param height height of the output figure
##' @param append append or not
##' @param devsize Boolean value show use device size or not (default = FALSE)
##' @param units the units in which to return the value – inches, cm, or pixels (device units)
##' @examples
##' if(interactive()){
##' plot(mtcars$mpg, mtcars$disp)
##' todocx(filename = file.path(tempdir(), "mtcars.docx"))
##' ## use ggplot2
##' ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
##' todocx(filename = file.path(tempdir(), "mtcars.docx"), height = 6, width = 4)
##' }
##' @author Kai Guo
##' @export
todocx <- function(figure =NULL, filename = NULL, title = "", width = 6, height = 6,
                    append = FALSE, devsize = FALSE, units = "in"){
    toffice(figure = figure, filename = filename, format = "docx", title = title,
            width = width, height = height,append = append, devsize = devsize,
            units = units)
}

##' export figure to pptx
##' @name toxlsx
##' @param figure plot figure function
##' @param filename output filename
##' @param width width of the output figure
##' @param height height of the output figure
##' @param devsize Boolean value show use device size or not (default = FALSE)
##' @param units the units in which to return the value – inches, cm, or pixels (device units)
##' @examples
##' if(interactive()){
##' plot(mtcars$mpg, mtcars$disp)
##' toxlsx(filename = file.path(tempdir(), "mtcars.xlsx"))
##' ## use ggplot2
##' ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
##' toxlsx(filename = file.path(tempdir(), "mtcars.xlsx"))
##' }
##' @author Kai Guo
##' @export
toxlsx <- function(figure = NULL, filename = NULL, width = 6, height = 6,
                   devsize = FALSE, units = "in"){
    toffice(figure = figure, filename = filename, format = "xlsx", title = "",
            width = width, height = height,  devsize = devsize,
            units = units)
}
