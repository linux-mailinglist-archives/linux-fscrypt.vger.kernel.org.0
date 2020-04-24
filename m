Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256561B813F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXUzf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:35 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638FFC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:35 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e17so5718026qtp.7
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ISodVqDbD/jpiJYrJUZk/jj6kfl5zo572iUjHRKuik=;
        b=Eatl0i4uy3jK5ugP3kHxNErJ4lwprXB6YYYmxYhJFz8n9Eq1ibA41IQiQ1Lj5dBqkE
         5+UJ2HTaOmPlgUV9PzJYxslrVQwgpbU2efDYlzAGu+Tpy7dXiJcouXO0rLDGti4r3n8h
         BMkr07an9/O6RkhQ9dp19VAts2qknUuEZQGj5uV/Eni4Ri/+hKeKSc1KxtM5ypUckxwC
         7P0rhGLujsTcohKMgDhOcjGuP6TGNtWtUgSJgjAOMRUXFfMXG6VIQg5QZeRbLySeuWdW
         YEVJKyE16KqGLwM2S8arNNCGD7BsNdQ/I/GNszEZHg2aOuV5prL+ijt8ZzBGPw+9TNfK
         K+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ISodVqDbD/jpiJYrJUZk/jj6kfl5zo572iUjHRKuik=;
        b=a+mu+0AAZC1SXViR94BbiVmDpeQiROPD0kA3XvktLqpTCsh3cAJyha89+o1Rl6UaC+
         2z/4rPcP+R4dzi851ABT+CJMdzgktJpgCXjhi9gijjJUopcG+Td2p5V23W9Xl5LDE1D7
         l+PICI3zACcoJdDY/2q8wOfI1O576m0MfD93fMr9wdYrmK8ov+EKLY+bMefRx6IComeF
         LS+xSqd3e5ewIAHeAC3YUSWacP/osEkkxBS5sB9mi+tqRZuFxoTy0Y4jqi5+vgpJpsWQ
         skTQ5fK+yR/VJwfMLidsXddmhuosZZ0lMSvQCM3KFUJX3SlDC2e97RFCkOWMVIxdP45f
         CvSA==
X-Gm-Message-State: AGi0PuZJcUq5TbrqsbPuaZdnHY4veBPazphMMpyqKVyAGWe7Xt3Qi3Jf
        ETJ72+yp8r9v/3zVlrBgqSSJJk8WF1A=
X-Google-Smtp-Source: APiQypLGRpwB4o6BJ4sMYIJF9XDoUxcru0IGV1u8NoX0hHnAjhnb2MEp5+KRdJL+Ni//SxdX2C457w==
X-Received: by 2002:ac8:346f:: with SMTP id v44mr11284272qtb.27.1587761734268;
        Fri, 24 Apr 2020 13:55:34 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id l12sm2971674qke.89.2020.04.24.13.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:33 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 16/20] libfsverity_sign_digest() use ARRAY_SIZE()
Date:   Fri, 24 Apr 2020 16:55:00 -0400
Message-Id: <20200424205504.2586682-17-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 libverity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libverity.c b/libverity.c
index 975d86e..7908dcd 100644
--- a/libverity.c
+++ b/libverity.c
@@ -521,8 +521,7 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 	if (!sig_params->keyfile || !sig_params->certfile)
 		return -EINVAL;
 
-	for (i = 0; i < sizeof(sig_params->reserved) /
-		     sizeof(sig_params->reserved[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(sig_params->reserved); i++) {
 		if (sig_params->reserved[i])
 			return -EINVAL;
 	}
-- 
2.25.3

