import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EcommerceChatBot extends StatefulWidget {
  const EcommerceChatBot({super.key});

  @override
  State<EcommerceChatBot> createState() => _EcommerceChatBotState();
}

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});
}

class _EcommerceChatBotState extends State<EcommerceChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isTyping = false;
  bool _apiError = false;

  @override
  void initState() {
    super.initState();
    // رسالة ترحيب خاصة بالتجارة الإلكترونية
    _addMessage(
      'مرحباً! أنا مساعدك الذكي في متجرنا. يمكنني مساعدتك في: '
      'المنتجات المتاحة، التوصيل والشحن، سياسة الإرجاع، '
      'تتبع الطلبيات، العروض والتخفيضات، وأي استفسارات أخرى. '
      'كيف يمكنني مساعدتك اليوم؟',
      false,
    );
  }

  void _addMessage(String text, bool isUser) {
    if (!mounted) return;
    setState(() {
      _messages.add(
        Message(text: text, isUser: isUser, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _addMessage(text, true);
    setState(() {
      _isTyping = true;
    });
    
    // محاكاة استجابة من الذكاء الاصطناعي مع ردود مسبقة الصنع
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    setState(() => _isTyping = false);
    
    // إجابة ذكية مسبقة الصنع بناءً على سؤال المستخدم
    final response = _getPredefinedResponse(text);
    _addMessage(response, false);
  }

  String _getPredefinedResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('شحن') || lowerMessage.contains('توصيل')) {
      return 'نقدم خدمة الشحن لجميع أنحاء البلاد خلال 2-5 أيام عمل. التوصيل مجاني للطلبات فوق 200 ريال. هل تود معرفة المزيد عن سياسة الشحن؟';
    } 
    else if (lowerMessage.contains('إرجاع') || lowerMessage.contains('استبدال')) {
      return 'سياسة الإرجاع لدينا تسمح بإرجاع المنتجات خلال 14 يومًا من الاستلام بشروط محددة. المنتجات يجب أن تكون في حالتها الأصلية وغير مستعملة. هل هناك منتج محدد تود استبداله؟';
    }
    else if (lowerMessage.contains('تخفيض') || lowerMessage.contains('عرض') || lowerMessage.contains('خصم')) {
      return 'حاليًا لدينا عروض على قسم الإلكترونيات والملابس. خصم يصل إلى 30% على منتجات مختارة. هل تود أن أطلعك على العروض الحالية؟';
    }
    else if (lowerMessage.contains('طلب') || lowerMessage.contains('طلبي')) {
      return 'لمساعدتك في تتبع طلبك، أحتاج إلى رقم الطلب. أو يمكنك الدخول إلى حسابك في المتجر لمشاهدة حالة الطلب. هل لديك رقم الطلب؟';
    }
    else if (lowerMessage.contains('دفع') || lowerMessage.contains('الدفع')) {
      return 'نحن نقبل多种طرق الدفع: البطاقات الائتمانية، التحويل البنكي، الدفع عند الاستلام. جميع معاملات الدفع لدينا آمنة ومشفرة.';
    }
    else if (lowerMessage.contains('منتج') || lowerMessage.contains('سلعة')) {
      return 'لدينا آلاف المنتجات في مختلف الأقسام: الإلكترونيات، الملابس، المنزل، الجمال. هل تبحث عن منتج معين أو في قسم محدد؟';
    }
    else if (lowerMessage.contains('حساب') || lowerMessage.contains('تسجيل')) {
      return 'يمكنك إنشاء حساب جديد من خلال النقر على "تسجيل" في أعلى الصفحة. سيسمح لك ذلك بتتبع طلباتك وحفظ عناوين الشحن والمزيد.';
    }
    else if (lowerMessage.contains('ساعات') || lowerMessage.contains('عمل')) {
      return 'خدمة العملاء متاحة من الأحد إلى الخميس، من 8 صباحًا إلى 10 مساءً. يمكنك التواصل معنا عبر الهاتف أو البريد الإلكتروني أو الدردشة الحية.';
    }
    else {
      return 'شكرًا لاستفسارك! كيف يمكنني مساعدتك اليوم؟ يمكنني مساعدتك في: المنتجات، الشحن، الإرجاع، العروض، أو تتبع الطلبات.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Iconsax.arrow_left, color: isDarkMode ? Colors.white : Colors.white),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مساعد المتجر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'نساعدك في تجربة تسوق أفضل',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_apiError)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: isDarkMode ? Colors.orange[800] : Colors.orange[100],
              child: Row(
                children: [
                  Icon(Icons.warning, color: isDarkMode ? Colors.orange[100] : Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الخدمة غير متاحة حالياً. جاري استخدام الردود المحلية.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.orange[100] : Colors.orange[800]
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator(isDarkMode);
                }
                final message = _messages[index];
                return _buildMessageBubble(message, isDarkMode);
              },
            ),
          ),
          _buildInputArea(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.shopping_cart, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? AppColors.primary 
                  : isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser 
                    ? Colors.white 
                    : isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.person, 
                size: 20, 
                color: isDarkMode ? Colors.grey[300] : Colors.grey[600]
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: const Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0, isDarkMode),
                const SizedBox(width: 4),
                _buildTypingDot(1, isDarkMode),
                const SizedBox(width: 4),
                _buildTypingDot(2, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.5, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'اسأل عن المنتجات، الشحن، التخفيضات، أو أي استفسار آخر...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[500]
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  textInputAction: TextInputAction.send,
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _isTyping ? null : _sendMessage,
                icon: Icon(
                  _isTyping ? Icons.hourglass_empty : Icons.send,
                  color: Colors.white,
                ),
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}