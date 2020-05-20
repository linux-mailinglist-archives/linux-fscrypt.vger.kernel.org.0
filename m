Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120691DC154
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgETVZr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgETVZq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:25:46 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4A7C061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:46 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id z80so5249784qka.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7jVx9lAyrduCOQuFjSIlc+xK1IAyZsWzbEeWoT0wAvw=;
        b=i7ao8/Cj5u1C6J5Zi4dE4bJwq6CiqSqDtUcUFcwBOlQpLm1DHm2775FgGY4zI37G91
         2DJSbK9o1LItFDkYd+m8vBVf3wO808r7xFr7Ggrq9Btv7EOORu+s4KfKTj3FQsXEITbH
         WUjlfykQBeMb3vultrJZ5VNBloEUpojI/GvtjKNf32Tf/q3lp+kVKnvvQIrLia9GcVSc
         J5dE2IqIrciqEFDws+StTDH6doIQbpUOJ22kVjHY+01vXjvCN5WVoIY9U9rOi8t3caBx
         JtXEFiTj8HabalYM5sR0hjVlLUvI9TqtdfdyblNhWp+QxADTIfRuGO/o6jW8Gz9F6pMI
         MG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7jVx9lAyrduCOQuFjSIlc+xK1IAyZsWzbEeWoT0wAvw=;
        b=jF2EoCod874aBkLjCOLs8IqBAnNqt98Zf3B8pjc5IyuslCeuCCbpzVAAzHDLUSh0VE
         gb2rqM3X8gVgIaUtTPn6DxNBprSjd7Ex6Yi6oIgkRrLtsLU3RWMKxamGOwYQ1C941Fp8
         p0RRkn1MrMn7V6hgiL8aQ5pLdsVQg7cGpvo0i8F7OGiD+9/5YlUtWyShdGm8goK7thNZ
         KplAN8p1qXMb7P9gIVsDBSuDOenR4dA3z9IBYZCBQX8wgLCKz+D3pX+VkUaz6zo0/5GC
         Q9nzXB+6ILpj4Cz1IW/I5Ihf9Q1/7mcncmkiXnmX5V4JsVPyHJOOKMH2xO1iOPaKs5hk
         6BAg==
X-Gm-Message-State: AOAM533sewaWWzSzuW12H75LCxDjWAdTJqFQ22Lrfn2nF9Ho7DQ5x8pP
        M7D3HNyqsM1Egz/yryaXb8U=
X-Google-Smtp-Source: ABdhPJyOuFOaN6CeS+fL3u5WKBAqNoT8dWVUFqOSyrmYi6NknpMcystVvDccniaHteRt6odSTfCF/Q==
X-Received: by 2002:a37:48c8:: with SMTP id v191mr7262940qka.268.1590009945171;
        Wed, 20 May 2020 14:25:45 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id 28sm3190798qkr.96.2020.05.20.14.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 14:25:43 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v3 0/2] fsverity-utils Makefile fixes
Date:   Wed, 20 May 2020 17:25:38 -0400
Message-Id: <20200520212540.263946-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi,

This addresses the last comments, leaving the CPPFLAGS as override. I
checked that it doesn't break the rpm build as well.

Cheers,
Jes


Jes Sorensen (2):
  Fix Makefile to delete objects from the library on make clean
  Let package manager override CFLAGS and CPPFLAGS

 Makefile | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

-- 
2.26.2

