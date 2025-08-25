import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { ChatService } from '../services/chat.service';
import { ChatMessage } from '../models/chat-message';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.scss']
})
export class ChatComponent implements OnInit, OnDestroy {
  messages: ChatMessage[] = [];
  newMessage = '';
  sender = 'Client';
  isConnected = false;
  connectionStatus = 'Déconnecté';
  private messageSub!: Subscription;
  private connectionCheckInterval: any;

  constructor(private chatService: ChatService) { }

  ngOnInit() {
    this.startConnection();
    
    this.messageSub = this.chatService.getMessage().subscribe((message: ChatMessage) => {
      this.messages.push(message);
    });

    // Vérifier régulièrement la connexion
    this.connectionCheckInterval = setInterval(() => {
      this.isConnected = this.chatService.isConnected();
      this.connectionStatus = this.isConnected ? 'Connecté' : 'Déconnecté';
    }, 1000);
  }

  startConnection() {
    setTimeout(() => {
      this.chatService.connect();
      this.checkConnectionStatus();
    }, 1000); // Délai pour permettre le chargement des scripts
  }

  checkConnectionStatus() {
    this.isConnected = this.chatService.isConnected();
    this.connectionStatus = this.isConnected ? 'Connecté' : 'Déconnecté';
    
    if (!this.isConnected) {
      setTimeout(() => this.checkConnectionStatus(), 1000);
    }
  }

  sendMessage() {
    if (this.newMessage.trim() && this.sender.trim()) {
      const message: ChatMessage = {
        sender: this.sender,
        content: this.newMessage,
        timestamp: new Date()
      };
      
      this.chatService.sendMessage(message);
      this.newMessage = '';
    }
  }

  reconnect() {
    this.chatService.disconnect();
    setTimeout(() => {
      this.chatService.connect();
      this.checkConnectionStatus();
    }, 500);
  }

  ngOnDestroy() {
    if (this.messageSub) {
      this.messageSub.unsubscribe();
    }
    if (this.connectionCheckInterval) {
      clearInterval(this.connectionCheckInterval);
    }
    this.chatService.disconnect();
  }
}