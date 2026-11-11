
package com.queueless.model;
public class Service {
    private int serviceId;
    private String serviceName;
    private String category;
    private String location;
    private String description;
    private int averageWaitTime;
    private int maxTokens;
    private String status;
    public Service() {
    }
    public Service(int serviceId, String serviceName, String category, String location, String description, int averageWaitTime, int maxTokens, String status) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.category = category;
        this.location = location;
        this.description = description;
        this.averageWaitTime = averageWaitTime;
        this.maxTokens = maxTokens;
        this.status = status;
    }
    public int getServiceId() {
        return serviceId;
    }
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    public String getServiceName() {
        return serviceName;
    }
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public int getAverageWaitTime() {
        return averageWaitTime;
    }
    public void setAverageWaitTime(int averageWaitTime) {
        this.averageWaitTime = averageWaitTime;
    }
    public int getMaxTokens() {
        return maxTokens;
    }
    public void setMaxTokens(int maxTokens) {
        this.maxTokens = maxTokens;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
