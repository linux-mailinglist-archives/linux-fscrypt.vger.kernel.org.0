Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2B21D5B10
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 22:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgEOU44 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 16:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgEOU4y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 16:56:54 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7090C061A0C
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:56:54 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id n14so4065665qke.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPSDtPaaKWXBHngF3kuAA5MKpeIFwaUHZiCgKfYSrQ0=;
        b=Fy/vt1VoutFCSwej+8vfQ4+u0XzdVEOUkDPb7WA+uszULT61C0LmHSbKTpnvHn4rU6
         bbKCacldcpLk2XL0PAQHlVt2aOk6Jy1gMs02kTcNHvZpB29Yh9Uad303blGvd/Jzdth4
         0Q4G4JgSyxIAP2Lz3k2G8qIWiW03sJJBVgWEkwsTW3typi2cNd1gvczvOVx/amYmPxXd
         U0eMIynot8udJetffDcUPXsJ/jyPEttXdd5xWNskMQx+5gmsKT0lS6QX4IE2KuFlM8IF
         dEB5noi16OUT36ipy1hlKC2QSQftiN4ostO/sG8yxqjGj+vyiCTPlpusfT85qucaoS1h
         cyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPSDtPaaKWXBHngF3kuAA5MKpeIFwaUHZiCgKfYSrQ0=;
        b=ND9BoiCVU0z+k92twuNIM5pSfkagm8lZR4viHD42EHD3bQ7GYHF+Aq97i3b9pP9QJy
         fZyffx7/ISz/8w5PVMDiWUuBwe29QkrENFzgtQ9rIly9mHQb7D68xnk0Hxr6rAEpLdIo
         th1J6fuqQJU8/k2rz2bn2V82pXnCoY0PdPc5XDv98w1vxwIoFOUoH8IbCvQ0U9yjhM0U
         HXV5SKST0QPR0LbYTr36MT3y8szUaH5+4L1wxH7lMAipcnXWuGQLvtZG1fJVnYszSb4f
         Egnhv3pYSYRHEpJD41CrkMgPsLXFOikG+72kVaVNi0vKN2zQPmrg4cTmq0cz2ReY1b0i
         o6WA==
X-Gm-Message-State: AOAM530Cp3ugal1P84tzvv1TkkYNrCYSowvcFnGcpAp865WuoqSMX3yD
        qFXzK3km5RW1w0VvXboAmaE=
X-Google-Smtp-Source: ABdhPJxltOCs6gOrnWZIMp+xDNI1VbQKMssyFFf297sXjlWCE+OhDHk1shGvIp5YpTPLObexVZN+oA==
X-Received: by 2002:a05:620a:1326:: with SMTP id p6mr5694616qkj.373.1589576213714;
        Fri, 15 May 2020 13:56:53 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1b31])
        by smtp.gmail.com with ESMTPSA id h13sm2971483qti.32.2020.05.15.13.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:56:52 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 0/2] fsverity-utils Makefile fixes
Date:   Fri, 15 May 2020 16:56:47 -0400
Message-Id: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi,

This set goes on top of the libfsverity changes from Eric.

One deals with the Makefile not cleaning up the library when running
'make clean'.

The second removes the forced override of CFLAGS and CPPFLAGS. This
really shouldn't be forced like it was, since package managers and
builders should be able to specify their preferred flags.

With these applied, I am able to build an rpm of fsverity-utils which
provides fsverity-utils and fsverity-utils-devel.

Should we bump the version to 1.1 or 1.0.1 or something too?

Once this is pushed to the official branch, I'll do an updated package
for Fedora Rawhide and do another pull-request for the RPM code.

Cheers,
Jes


Jes Sorensen (2):
  Fix Makefile to delete objects from the library on make clean
  Let package manager override CFLAGS and CPPFLAGS

 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.26.2

