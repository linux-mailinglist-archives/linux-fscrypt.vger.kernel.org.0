Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6900174171
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Feb 2020 22:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgB1V2W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Feb 2020 16:28:22 -0500
Received: from mail-qk1-f174.google.com ([209.85.222.174]:37708 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1V2V (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Feb 2020 16:28:21 -0500
Received: by mail-qk1-f174.google.com with SMTP id m9so4460906qke.4
        for <linux-fscrypt@vger.kernel.org>; Fri, 28 Feb 2020 13:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZhNDk+EfUriWY05th+r5spcEiqgbSZ+ChFYbiImYMf4=;
        b=DFIw5e5loj0hgdbPE4lA+5bs3mc8gW2D8lO5CPgA/f/LEpNwe0NpAa2m1skN1fj48m
         werFgoItUXBsDMAxWh/e84MCf5vnBlonGuB40SGBNWwqQLlHmigcwxEOi/snAP8FNTOy
         OeZkSDLEJT6SMNslkOmK06THyytNhnV+nWmy2Gu6Qy6Ec+XcvnVKy1WGqRlfKaQvn6l5
         GKNW+2OWP+ruyUikXIgNVV0TOyKIncnzPUjzUJK3WwMkzHIp3GYy0kcBHkqT2JAvRuZr
         aM/WbTY+4vIXvpAQLpveNNwkyCft1/7OpNiq8r1kgbKHsXVChNhLMQPNMM8Jz80m7QJE
         qHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZhNDk+EfUriWY05th+r5spcEiqgbSZ+ChFYbiImYMf4=;
        b=rOQvMD1pNcgprzsUesbBdSZ4wk5v7dEMmYIqcfw3NlsGiEOg9JATMgdVGdtYJ1j3/S
         fvJB7VlrixaPuI8buXnFsCDBP06J4lRwBrKDZap5dyZvOashSBrhhZF31W2dHq952eiS
         gd8vnxkQEwC6jOWpZOED0YkY640a9AT9QHw3ZE30iNXjXB59cCyPZ0p2cvQSg1ZBfuXX
         3n/s+KXIkPNt9o88YP6/J3eryw/zCFWgvDxoAwJ1PS+W5ePqCPIsj06RAbfeivIs56sw
         aUILXvbrpUlpm/lwpqUD+73G9pgLPkIpAbG7MF3KnCEUlCBDpabEFN8sQIVTVsCf9L+t
         NkhQ==
X-Gm-Message-State: APjAAAVH9bGe1ftYsUn32c/H11g/LnIin6emCF0jy7meDsGQMaAm7qh2
        Taw2/delVB8BezSXjf9LUgDOp/OM
X-Google-Smtp-Source: APXvYqyFmOyGVVOr458/mNSxq2DwM5iNqbDudbUcKMeCXfVNpr9zIGaCw9AmFvbZoug/OOdKRb6gIg==
X-Received: by 2002:a37:9a8b:: with SMTP id c133mr6139498qke.132.1582925298649;
        Fri, 28 Feb 2020 13:28:18 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::1:bc9d])
        by smtp.gmail.com with ESMTPSA id 64sm5827175qkd.78.2020.02.28.13.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:28:18 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v2 0/6] Split fsverity-utils into a shared library
Date:   Fri, 28 Feb 2020 16:28:08 -0500
Message-Id: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi,

Here is a reworked version of the patches to split fsverity-utils into
a shared library, based on the feedback for the original version. Note
this doesn't yet address setting the soname, and doesn't have the
client (rpm) changes yet, so there is more work to do.

Comments appreciated.

Cheers,
Jes

Jes Sorensen (6):
  Build basic shared library framework
  Change compute_file_measurement() to take a file descriptor as
    argument
  Move fsverity_descriptor definition to libfsverity.h
  Move hash algorithm code to shared library
  Create libfsverity_compute_digest() and adapt cmd_sign to use it
  Introduce libfsverity_sign_digest()

 Makefile      |  18 +-
 cmd_enable.c  |  11 +-
 cmd_measure.c |   4 +-
 cmd_sign.c    | 526 ++++----------------------------------------------
 fsverity.c    |  15 ++
 hash_algs.c   |  26 +--
 hash_algs.h   |  27 ---
 libfsverity.h |  99 ++++++++++
 libverity.c   | 526 ++++++++++++++++++++++++++++++++++++++++++++++++++
 util.h        |   2 +
 10 files changed, 707 insertions(+), 547 deletions(-)
 create mode 100644 libfsverity.h
 create mode 100644 libverity.c

-- 
2.24.1

