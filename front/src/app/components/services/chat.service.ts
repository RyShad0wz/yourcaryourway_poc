import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { ChatMessage } from '../models/chat-message';
import { environment } from '../../environments/environment';

// Déclaration des variables globales
declare const SockJS: any;
declare const Stomp: any;

@Injectable({ providedIn: 'root' })
export class ChatService {
  private stompClient: any;
  private messageSubject = new BehaviorSubject<ChatMessage>({} as ChatMessage);
  private connected = false;

  constructor() {
    this.loadStompScripts();
  }

  private loadStompScripts(): void {
    // Charger SockJS depuis CDN
    if (typeof SockJS === 'undefined') {
      const sockjsScript = document.createElement('script');
      sockjsScript.src = 'https://cdn.jsdelivr.net/npm/sockjs-client@1.5.2/dist/sockjs.min.js';
      sockjsScript.onload = () => this.loadStomp();
      document.head.appendChild(sockjsScript);
    } else {
      this.loadStomp();
    }
  }

  private loadStomp(): void {
    // Charger Stomp depuis CDN
    if (typeof Stomp === 'undefined') {
      const stompScript = document.createElement('script');
      stompScript.src = 'https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js';
      stompScript.onload = () => this.initializeConnection();
      document.head.appendChild(stompScript);
    } else {
      this.initializeConnection();
    }
  }

  private initializeConnection(): void {
    // Attendre que les scripts soient chargés
    if (typeof SockJS === 'undefined' || typeof Stomp === 'undefined') {
      setTimeout(() => this.initializeConnection(), 100);
      return;
    }
  }

  connect(): void {
    if (this.connected) return;

    try {
      const socket = new SockJS(`${environment.webSocketUrl}`);
      this.stompClient = Stomp.over(socket);
      
      this.stompClient.connect({}, () => {
        this.connected = true;
        this.stompClient.subscribe('/topic/messages', (message: any) => {
          const chatMessage: ChatMessage = JSON.parse(message.body);
          this.messageSubject.next(chatMessage);
        });
      }, (error: any) => {
        console.error('WebSocket connection error:', error);
        this.connected = false;
      });
    } catch (error) {
      console.error('SockJS initialization error:', error);
      this.connected = false;
    }
  }

  sendMessage(message: ChatMessage): void {
    if (this.stompClient && this.connected) {
      try {
        this.stompClient.send('/app/chat.send', {}, JSON.stringify(message));
      } catch (error) {
        console.error('Error sending message:', error);
      }
    } else {
      console.warn('WebSocket not connected. Attempting to reconnect...');
      this.connect();
      setTimeout(() => this.sendMessage(message), 1000);
    }
  }

  getMessage(): Observable<ChatMessage> {
    return this.messageSubject.asObservable();
  }

  isConnected(): boolean {
    return this.connected;
  }

  disconnect(): void {
    if (this.stompClient) {
      this.stompClient.disconnect();
      this.connected = false;
    }
  }
}