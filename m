Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DC41D031A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 01:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbgELXgI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 19:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELXgH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 19:36:07 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C09620769;
        Tue, 12 May 2020 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589326567;
        bh=/L5xK29ViM6H3K9diQ/RKFdZi3A2yxf+q63QlofvZKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SITX0Uc6cMqd/Nx4GmNh0VLRUjEvlCxuKD67PPh8tGhogHIO8Tac4vLmagL3S5tek
         xnJqA+d98BFL7TRYI+7VEKSZNKuWmBGbrMI9mjHKr/wrjKCPjP0k/vBUGEcssM1Qf4
         C1jbi5q9p7UHDRxUrzBVEqdWLDAidSecKoRobD28=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 1/4] linux/parser.h: add include guards
Date:   Tue, 12 May 2020 16:32:48 -0700
Message-Id: <20200512233251.118314-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512233251.118314-1-ebiggers@kernel.org>
References: <20200512233251.118314-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

<linux/parser.h> is missing include guards.  Add them.

This is needed to allow declaring a function in <linux/fscrypt.h> that
takes a substring_t parameter.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/parser.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/parser.h b/include/linux/parser.h
index 12fc3482f5fc7a..89e2b23fb888e8 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -7,7 +7,8 @@
  * but could potentially be used anywhere else that simple option=arg
  * parsing is required.
  */
-
+#ifndef _LINUX_PARSER_H
+#define _LINUX_PARSER_H
 
 /* associates an integer enumerator with a pattern string. */
 struct match_token {
@@ -34,3 +35,5 @@ int match_hex(substring_t *, int *result);
 bool match_wildcard(const char *pattern, const char *str);
 size_t match_strlcpy(char *, const substring_t *, size_t);
 char *match_strdup(const substring_t *);
+
+#endif /* _LINUX_PARSER_H */
-- 
2.26.2

