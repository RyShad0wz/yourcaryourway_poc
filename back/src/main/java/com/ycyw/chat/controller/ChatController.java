package com.ycyw.chat.controller;

import com.ycyw.chat.entity.ChatMessage;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {

    @MessageMapping("/chat.send")
    @SendTo("/topic/messages")
    public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
        System.out.println("Message reçu de " + chatMessage.getSender() + ": " + chatMessage.getContent());
        return chatMessage;
    }
}
