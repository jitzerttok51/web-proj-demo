package com.example.webprojdemo;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class StorageService {

    private final AmazonS3 client;

    private final String bucketName;

    private final String bucketURL;

    public StorageService(String doSpaceKey, String doSpaceSecret, String doSpaceEndpoint,
        String doSpaceRegion, String doSpaceBucket, String bucketURL) {
        BasicAWSCredentials creds = new BasicAWSCredentials(doSpaceKey, doSpaceSecret);
        this.client = AmazonS3ClientBuilder
                          .standard()
                          .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(doSpaceEndpoint, doSpaceRegion))
                          .withCredentials(new AWSStaticCredentialsProvider(creds)).build();
        this.bucketName = doSpaceBucket;
        this.bucketURL = bucketURL;
    }

    public void saveFile(MultipartFile file, String name) throws IOException {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getInputStream().available());
        if (file.getContentType() != null && !"".equals(file.getContentType())) {
            metadata.setContentType(file.getContentType());
        }
        client.putObject(new PutObjectRequest(bucketName, name, file.getInputStream(), metadata)
                               .withCannedAcl(CannedAccessControlList.PublicRead));
    }

    public void saveFile(Path file, String name) throws IOException {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(Files.size(file));
        try(var in = Files.newInputStream(file)) {
            client.putObject(new PutObjectRequest(bucketName, name, in, metadata)
                                 .withCannedAcl(CannedAccessControlList.PublicRead));
        }
    }
}
