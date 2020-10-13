package com.document.converter.controller;

import com.document.converter.service.ConverterService;
import org.apache.commons.io.FilenameUtils;
import org.jodconverter.core.document.DefaultDocumentFormatRegistry;
import org.jodconverter.core.document.DocumentFormat;
import org.jodconverter.core.office.OfficeException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

@RestController
@RequestMapping("/converter/v1")
public class ConverterController {
    @Autowired
    private ConverterService converterService;

    private final String PDF_FORMAT = "pdf";

    @PostMapping(path = "/pdf")
    public ResponseEntity<?> convert(
            @RequestParam("file") final MultipartFile inputMultipartFile) throws
            IOException, OfficeException {

        final DocumentFormat conversionTargetFormat =
                DefaultDocumentFormatRegistry.getFormatByExtension(PDF_FORMAT);

        ByteArrayOutputStream convertedFile = converterService.doConvert(
                conversionTargetFormat,
                inputMultipartFile.getInputStream()
        );


        final HttpHeaders headers = new HttpHeaders();
        String targetFilename = String.format(
                "%s.%s",
                FilenameUtils.getBaseName(inputMultipartFile.getOriginalFilename()),
                conversionTargetFormat.getExtension()
        );
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + targetFilename);
        headers.setContentType(MediaType.parseMediaType(conversionTargetFormat.getMediaType()));
        return ResponseEntity.ok().headers(headers).body(convertedFile.toByteArray());
    }

}
