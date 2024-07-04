package com.example.webprojdemo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
public class StorageConfig {

    @Bean
    @Profile("!test")
    public StorageService storageService(
        @Value("${bucket.key}") String doSpaceKey,
        @Value("${bucket.secret}") String doSpaceSecret,
        @Value("${bucket.endpoint}") String doSpaceEndpoint,
        @Value("${bucket.region}") String doSpaceRegion,
        @Value("${bucket.name}") String doBucketName,
        @Value("${bucket.url}") String doBucketURL
    ) {
        return new StorageService(doSpaceKey, doSpaceSecret, doSpaceEndpoint, doSpaceRegion, doBucketName, doBucketURL);
    }
}
