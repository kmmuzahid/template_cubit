import 'package:core_kit/core_kit_internal.dart';

class InfoRepository {
  InfoRepository();

  Future<CkResponse<String>> getPrivacyPolicy() async {
    //simulation, remove in production
    await Future.delayed(Duration(microseconds: 500));

    return CkResponse(
      isSuccess: true,
      message: "Success",
      statusCode: 200,
      data: '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Privacy Policy</title>
  <style>
    :root {
      --primary: #2563eb;
      --text: #1e293b;
      --text-muted: #64748b;
      --bg: #f8fafc;
      --card-bg: #ffffff;
      --border: #e2e8f0;
      --accent: #eff6ff;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      line-height: 1.7;
      color: var(--text);
      background-color: var(--bg);
      padding: 40px 20px;
    }

    .container {
      max-width: 1000px;
      margin: 0 auto;
      background: var(--card-bg);
      border-radius: 12px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
      border: 1px solid var(--border);
      overflow: hidden;
    }

    /* Header */
    .header {
      padding: 40px 48px;
      background: linear-gradient(135deg, #1e293b, #0f172a);
      color: #ffffff;
    }

    .header h1 {
      font-size: 2rem;
      margin-bottom: 8px;
      font-weight: 700;
    }

    .header p {
      color: #94a3b8;
      font-size: 0.95rem;
    }

    /* Layout */
    .layout {
      display: grid;
      grid-template-columns: 260px 1fr;
      min-height: 500px;
    }

    /* Sticky Sidebar */
    .sidebar {
      padding: 32px 24px;
      border-right: 1px solid var(--border);
      background-color: #fafbfc;
    }

    .nav-list {
      position: sticky;
      top: 24px;
      list-style: none;
    }

    .nav-list li {
      margin-bottom: 8px;
    }

    .nav-list a {
      display: block;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 0.95rem;
      padding: 8px 12px;
      border-radius: 6px;
      transition: all 0.2s ease;
    }

    .nav-list a:hover {
      color: var(--primary);
      background-color: var(--accent);
    }

    /* Main Content */
    .content {
      padding: 40px 48px;
      scroll-behavior: smooth;
    }

    section {
      margin-bottom: 40px;
    }

    section:last-child {
      margin-bottom: 0;
    }

    h2 {
      font-size: 1.35rem;
      color: var(--text);
      margin-bottom: 12px;
      padding-bottom: 8px;
      border-bottom: 1px solid var(--border);
    }

    p {
      margin-bottom: 14px;
      color: #334155;
      font-size: 0.95rem;
    }

    ul {
      margin-left: 20px;
      margin-bottom: 14px;
      color: #334155;
    }

    li {
      margin-bottom: 6px;
      font-size: 0.95rem;
    }

    .info-box {
      background-color: var(--accent);
      border-left: 4px solid var(--primary);
      padding: 16px 20px;
      border-radius: 4px;
      margin-top: 12px;
    }

    /* Footer */
    .footer {
      padding: 24px 48px;
      background: #fafbfc;
      border-top: 1px solid var(--border);
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 0.85rem;
      color: var(--text-muted);
    }

    .btn {
      background-color: var(--primary);
      color: white;
      padding: 8px 16px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 500;
      transition: opacity 0.2s;
    }

    .btn:hover {
      opacity: 0.9;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .layout {
        grid-template-columns: 1fr;
      }

      .sidebar {
        display: none;
      }

      .header, .content, .footer {
        padding: 24px;
      }
    }
  </style>
</head>
<body>

  <div class="container">
    <!-- Header -->
    <header class="header">
      <h1>Privacy Policy</h1>
      <p>Last updated: September 8, 2026</p>
    </header>

    <!-- Body Layout -->
    <div class="layout">
      <!-- Sticky Sidebar -->
      <aside class="sidebar">
        <ul class="nav-list">
          <li><a href="#collection">1. Data We Collect</a></li>
          <li><a href="#usage">2. How We Use Data</a></li>
          <li><a href="#cookies">3. Cookies & Tracking</a></li>
          <li><a href="#sharing">4. Third-Party Sharing</a></li>
          <li><a href="#rights">5. Your Data Rights</a></li>
          <li><a href="#security">6. Data Security</a></li>
          <li><a href="#contact">7. Contact Us</a></li>
        </ul>
      </aside>

      <!-- Main Content -->
      <main class="content">
        <section id="collection">
          <h2>1. Information We Collect</h2>
          <p>We collect information to provide better services to our users. The categories of information include:</p>
          <ul>
            <li><strong>Information you provide:</strong> Name, email address, billing details, and profile data when registering or purchasing.</li>
            <li><strong>Automatically collected information:</strong> Device type, IP address, operating system, and interactions with our application.</li>
          </ul>
        </section>

        <section id="usage">
          <h2>2. How We Use Your Information</h2>
          <p>We process your data strictly under valid legal grounds (such as contract fulfillment, legitimate interest, or explicit consent), including to:</p>
          <ul>
            <li>Deliver, operate, and maintain our application features.</li>
            <li>Process payments and authenticate secure user logins.</li>
            <li>Send critical account notices, updates, and security alerts.</li>
            <li>Prevent fraudulent transactions and unauthorized system access.</li>
          </ul>
        </section>

        <section id="cookies">
          <h2>3. Cookies and Local Storage</h2>
          <p>We use cookies, tokens, and local cache to enhance your experience, preserve user sessions, and gather aggregate usage analytics. You can configure your browser to reject cookies, though some parts of the service may not function properly.</p>
        </section>

        <section id="sharing">
          <h2>4. Third-Party Disclosures</h2>
          <p>We do not sell your personal data. We only share information with trusted third-party providers bound by data confidentiality agreements:</p>
          <ul>
            <li><strong>Payment Processors:</strong> To safely process payment credentials without storing card numbers on our servers.</li>
            <li><strong>Cloud Infrastructure:</strong> Secure cloud servers hosting encrypted application databases.</li>
            <li><strong>Legal Compliance:</strong> When required to comply with court orders, subpoenas, or applicable regulations.</li>
          </ul>
        </section>

        <section id="rights">
          <h2>5. Your Privacy Rights</h2>
          <p>Depending on your jurisdiction (such as GDPR or CCPA), you hold specific rights regarding your personal information:</p>
          <ul>
            <li><strong>Right to Access:</strong> Request an export of your stored personal data.</li>
            <li><strong>Right to Rectification:</strong> Update inaccurate or outdated profile details.</li>
            <li><strong>Right to Erasure:</strong> Request permanent deletion of your account and related records.</li>
            <li><strong>Opt-Out:</strong> Withdraw consent for non-essential marketing communications at any time.</li>
          </ul>
        </section>

        <section id="security">
          <h2>6. Data Security & Retention</h2>
          <p>We implement industry-standard administrative, physical, and technical safeguards (such as TLS encryption and restricted access controls) to protect your personal information. We retain personal records only as long as necessary to provide services or satisfy statutory record-keeping rules.</p>
        </section>

        <section id="contact">
          <h2>7. Contact the Data Protection Officer</h2>
          <p>If you have any questions or wish to exercise your data protection rights, please contact us:</p>
          <div class="info-box">
            <p><strong>Email:</strong> privacy@example.com</p>
            <p><strong>Address:</strong> 123 Business Road, Suite 100, City, Country</p>
          </div>
        </section>
      </main>
    </div>

    <!-- Footer -->
    <footer class="footer">
      <span>&copy; 2026 Your Company. All rights reserved.</span>
      <a href="mailto:privacy@example.com" class="btn">Exercise Data Rights</a>
    </footer>
  </div>

</body>
</html>''',
    );
  }

  Future<CkResponse<String>> getTermsAndConditions() async {
    // return  CkTransport.request<String>(

    // );

    //simulation, remove in production
    await Future.delayed(Duration(microseconds: 500));

    return CkResponse(
      isSuccess: true,
      message: "Success",
      statusCode: 200,
      data: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Terms & Conditions</title>
  <style>
    :root {
      --primary: #2563eb;
      --text: #1e293b;
      --text-muted: #64748b;
      --bg: #f8fafc;
      --card-bg: #ffffff;
      --border: #e2e8f0;
      --accent: #eff6ff;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      line-height: 1.7;
      color: var(--text);
      background-color: var(--bg);
      padding: 40px 20px;
    }

    .container {
      max-width: 1000px;
      margin: 0 auto;
      background: var(--card-bg);
      border-radius: 12px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
      border: 1px solid var(--border);
      overflow: hidden;
    }

    /* Header */
    .header {
      padding: 40px 48px;
      background: linear-gradient(135deg, #1e293b, #0f172a);
      color: #ffffff;
    }

    .header h1 {
      font-size: 2rem;
      margin-bottom: 8px;
      font-weight: 700;
    }

    .header p {
      color: #94a3b8;
      font-size: 0.95rem;
    }

    /* Main Layout */
    .layout {
      display: grid;
      grid-template-columns: 260px 1fr;
      min-height: 500px;
    }

    /* Sidebar Navigation */
    .sidebar {
      padding: 32px 24px;
      border-right: 1px solid var(--border);
      background-color: #fafbfc;
    }

    .nav-list {
      position: sticky;
      top: 24px;
      list-style: none;
    }

    .nav-list li {
      margin-bottom: 8px;
    }

    .nav-list a {
      display: block;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 0.95rem;
      padding: 8px 12px;
      border-radius: 6px;
      transition: all 0.2s ease;
    }

    .nav-list a:hover {
      color: var(--primary);
      background-color: var(--accent);
    }

    /* Content Area */
    .content {
      padding: 40px 48px;
      scroll-behavior: smooth;
    }

    section {
      margin-bottom: 40px;
    }

    section:last-child {
      margin-bottom: 0;
    }

    h2 {
      font-size: 1.35rem;
      color: var(--text);
      margin-bottom: 12px;
      padding-bottom: 8px;
      border-bottom: 1px solid var(--border);
    }

    p {
      margin-bottom: 14px;
      color: #334155;
      font-size: 0.95rem;
    }

    ul {
      margin-left: 20px;
      margin-bottom: 14px;
      color: #334155;
    }

    li {
      margin-bottom: 6px;
      font-size: 0.95rem;
    }

    .contact-box {
      background-color: var(--accent);
      border-left: 4px solid var(--primary);
      padding: 16px 20px;
      border-radius: 4px;
      margin-top: 12px;
    }

    /* Footer */
    .footer {
      padding: 24px 48px;
      background: #fafbfc;
      border-top: 1px solid var(--border);
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 0.85rem;
      color: var(--text-muted);
    }

    .btn {
      background-color: var(--primary);
      color: white;
      padding: 8px 16px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 500;
      transition: opacity 0.2s;
    }

    .btn:hover {
      opacity: 0.9;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .layout {
        grid-template-columns: 1fr;
      }

      .sidebar {
        display: none; /* Hide sidebar on mobile for simplicity */
      }

      .header, .content, .footer {
        padding: 24px;
      }
    }
  </style>
</head>
<body>

  <div class="container">
    <!-- Header -->
    <header class="header">
      <h1>Terms & Conditions</h1>
      <p>Last updated: September 8, 2026</p>
    </header>

    <!-- Body Layout -->
    <div class="layout">
      <!-- Sticky Sidebar -->
      <aside class="sidebar">
        <ul class="nav-list">
          <li><a href="#acceptance">1. Acceptance</a></li>
          <li><a href="#accounts">2. User Accounts</a></li>
          <li><a href="#usage">3. Acceptable Use</a></li>
          <li><a href="#ip">4. Intellectual Property</a></li>
          <li><a href="#termination">5. Termination</a></li>
          <li><a href="#contact">6. Contact Information</a></li>
        </ul>
      </aside>

      <!-- Main Content -->
      <main class="content">
        <section id="acceptance">
          <h2>1. Acceptance of Terms</h2>
          <p>By accessing or using our website and services, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you disagree with any part of these terms, you may not access the service.</p>
        </section>

        <section id="accounts">
          <h2>2. User Accounts</h2>
          <p>When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms.</p>
          <ul>
            <li>You are responsible for safeguarding your password.</li>
            <li>You must notify us immediately of any security breach.</li>
            <li>You may not use as a username the name of another person or entity.</li>
          </ul>
        </section>

        <section id="usage">
          <h2>3. Acceptable Use</h2>
          <p>You agree not to use the service for any purpose that is prohibited by these terms or by applicable law. You shall not:</p>
          <ul>
            <li>Disrupt or interfere with the security of the service.</li>
            <li>Attempt to reverse engineer or decompile any part of the system.</li>
            <li>Transmit any worms, viruses, or code of a destructive nature.</li>
          </ul>
        </section>

        <section id="ip">
          <h2>4. Intellectual Property</h2>
          <p>The Service and its original content, features, and functionality are and will remain the exclusive property of our company and its licensors. Our trademarks may not be used in connection with any product or service without prior written consent.</p>
        </section>

        <section id="termination">
          <h2>5. Termination</h2>
          <p>We may terminate or suspend your account and access to the Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.</p>
        </section>

        <section id="contact">
          <h2>6. Contact Us</h2>
          <p>If you have any questions about these Terms, please reach out to us:</p>
          <div class="contact-box">
            <p><strong>Email:</strong> support@example.com</p>
            <p><strong>Address:</strong> 123 Business Road, Suite 100, City, Country</p>
          </div>
        </section>
      </main>
    </div>

    <!-- Footer -->
    <footer class="footer">
      <span>&copy; 2026 Your Company. All rights reserved.</span>
      <a href="#" class="btn">Accept Terms</a>
    </footer>
  </div>

</body>
</html>''',
    );
  }
}
