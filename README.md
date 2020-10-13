# document-pdf-converter

## Spring Boot Service: Convert Word Document to PDF using JodConverter and Libre Office

# document-converter

This service will help you in document conversions, For Example Word to PDF (Word doc with merge fields)

![alt text](/readme-res/pdf.png)

## Local Development

> ### Pre-requisits

* Libre Office Installed on your local Machine [Link](https://www.libreoffice.org/download/download/). Make sure you download version 6.4.6, because this is the only supported version 😁

> ### Run and Debug

* Build maven project and run jar file as `java -jar application.jar`

## Usage

Service have only one end point.

> ### Request

* url: http://localhost:8080/converter/v1/pdf

* data: formData, add a word file as data.

* method/type: POST

> ### Response

Converted file as PDF

## JQuery Ajax Request

```html
<!DOCTYPE html>
<html>
    <head>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    </head>

    <body>
        <div class="upload-btn-wrapper">
            <input type="file" name="fileToConvert" id="fileToConvert"/>
          </div>
    </body>

</html>

<script>
    var url = "http://localhost:8080/converter/v1/pdf";
   $(document).ready(function () {
        $("#fileToConvert").change(function() {
            var formData = new FormData(); 
            formData.append('file', $("#fileToConvert")[0].files[0]);

            $.ajax({
                url: url,
                method: "POST",
                crossDomain: true,
                data: formData,
                contentType: false,
                processData: false,
                success: function(data) {
                    console.log(data);
                }
            });
        });
    });
</script>
```




## Jersy Web Client Request

```
import java.io.File;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.glassfish.jersey.media.multipart.file.FileDataBodyPart;

public class DocConvertClient {
	public static void main(String[] args) {
		final Client client = ClientBuilder
						.newBuilder()
						.register(MultiPartFeature.class).build();
		
		WebTarget target = client.target("http://localhost:8080/converter/v1/pdf");
		
		FileDataBodyPart filePart = new FileDataBodyPart("file", new File("E:\\withpictures.docx"));
		filePart.setContentDisposition(FormDataContentDisposition.name("file").fileName("withpictures.docx").build());
		
		MultiPart multipartEntity = new FormDataMultiPart().bodyPart(filePart);
		Response response = target
					.request()
					.post(Entity.entity(multipartEntity, multipartEntity.getMediaType()));
		
		System.out.println(response.getStatus());
		System.out.println(response.readEntity(String.class));
		
		response.close();
	}

}
```
