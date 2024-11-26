class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Quản lý Chi tiêu Dễ dàng',
      image: 'assets/images/pic1.jpg',
      discription:
          "Ứng dụng của chúng tôi giúp bạn theo dõi và quản lý chi tiêu hàng ngày một cách dễ dàng và hiệu quả. "
          "Với giao diện thân thiện và các tính năng thông minh, bạn sẽ luôn biết tiền của mình đi đâu. "),
  UnbordingContent(
      title: 'Tài chính trong Tầm tay',
      image: 'assets/images/pic2.jpg',
      discription:
          "Giải pháp tối ưu để quản lý tài chính cá nhân! Ứng dụng cho phép bạn ghi lại tất cả các khoản thu chi,  "
          "lên kế hoạch ngân sách, và theo dõi tiến độ tiết kiệm một cách chi tiết. "),
  UnbordingContent(
      title: 'Hiểu rõ Chi tiêu với Biểu đồ Thống kê',
      image: 'assets/images/pic3.jpg',
      discription:
          "Với tính năng biểu đồ thống kê, bạn sẽ có cái nhìn tổng quan về các khoản thu chi. "
          "Biểu đồ được thiết kế trực quan, dễ hiểu và cực kỳ hữu ích để bạn nắm bắt tình hình tài chính."),
];
