package com.ycyw.chat.entity;

import java.time.Instant;

public class ChatMessage {
    private String sender;
    private String content;
    private Instant timestamp;

    public ChatMessage() {
        this.timestamp = Instant.now();
    }

    public ChatMessage(String sender, String content) {
        this();
        this.sender = sender;
        this.content = content;
    }

    // Getters et Setters
    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Instant getTimestamp() { return timestamp; }
    public void setTimestamp(Instant timestamp) { this.timestamp = timestamp; }
}