Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0693CCA59
	for <lists+linux-fscrypt@lfdr.de>; Sun, 18 Jul 2021 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhGRTLb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Jul 2021 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhGRTLb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Jul 2021 15:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D26B611AF;
        Sun, 18 Jul 2021 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626635312;
        bh=r5GKDwHIuFUEDTItoSAvZd14IRRWgL8LQxq2MruHBUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+9SwPrLS06HHYB2nKk+wjRABUiMIlB516xXhD+3qr7omfnae4MHmqdmZN5r4NJD1
         vCGS7EVzzRzQpsFK4heoiFRA8C2Nk0HBUmCNqxOu9mAVQar0eSS39qG/xDO2AvE3wx
         c1oq1X4voy+CFIoGD0YSczZ6ggRn5JQGPStrzfXoR9FEm7va92h6J7g5w7ZvuNF+jf
         qE5HlXlcvHvMCI6umnP9psef45z0WgfWt9ZPGXoElVcHjEaBLdCahsXdz6srn0kLte
         Ub132fclubwHsGc1g/9V3ioDloxPhrksVS7Woz8+DKak25a/4dx1oV9KKvDjgqQfV6
         y1I+wS851zwqw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 3/3] common/encrypt: accept '-' character in no-key names
Date:   Sun, 18 Jul 2021 14:06:58 -0500
Message-Id: <20210718190658.61621-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210718190658.61621-1-ebiggers@kernel.org>
References: <20210718190658.61621-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add the '-' character to the regex that generic/{419,429} use to match
no-key filenames.  This is needed to prevent these tests from failing
after the kernel is changed to use a more standard variant of Base64
(https://lkml.kernel.org/r/20210718000125.59701-1-ebiggers@kernel.org).

Note that despite breaking these tests, the kernel change is not
expected to break any real users, as the fscrypt no-key name encoding
has always been considered an implementation detail.  So it is
appropriate to just update these tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/encrypt b/common/encrypt
index 766a6d81..f90c4ef0 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -935,5 +935,8 @@ _filter_nokey_filenames()
 {
 	local dir=$1
 
-	sed "s|${dir}${dir:+/}[A-Za-z0-9+,_]\+|${dir}${dir:+/}NOKEY_NAME|g"
+	# The no-key name format is a filesystem implementation detail that has
+	# varied slightly over time.  Just look for names that consist entirely
+	# of characters that have ever been used in such names.
+	sed "s|${dir}${dir:+/}[A-Za-z0-9+,_-]\+|${dir}${dir:+/}NOKEY_NAME|g"
 }
-- 
2.32.0

