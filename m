Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFED183BA8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCLVsF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:05 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41431 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:05 -0400
Received: by mail-qv1-f65.google.com with SMTP id a10so3478105qvq.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OokOmviM9dkj5rNcpUNrjzHkd/kUaJC8gwLZIMuqsj0=;
        b=Cs4rYRsZj3Kpqwfa2xqLjjVDjI9ySSsZ7R8Gcj9uuWQl155k/nPgNXWZ8quix3Nttp
         csD4QQoudTgfaX2MizfRU8W+cjO9U/ICZF0v4QMoWviOpHyv7WqbzFEvVQ71GCbm11ox
         cLvAAffjt6Rc8Kzf9eD1VGVG6XHp5MeGePBHTouRNSWkQ+E6DOS4dL5JY3hZX7xhs+W3
         mlua2tx1+ad3UXtciyUjHg4BymY+rX5rJUiKFmHpHnl34icet21PT9pyhKm+JahbZMB7
         LKSKYpba7iQLT3EIuY1oME8cQPbMllwmhKtZqyHN2SGFtBqchYIcs8/22jEmude0RJJ5
         HPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OokOmviM9dkj5rNcpUNrjzHkd/kUaJC8gwLZIMuqsj0=;
        b=DcvmtWwnIOLqj5LqDcvL94tRMqClqum/E/VXRedUtZijxgkdqhNr5heOrPb2UTC9J3
         fYthIJBh+gsLKOjNqmbYUrJwzCA5zXnSWY9Vh0X6TumrsHbvTgp/M/qUT7V95onvqMfI
         dGUZscBtahvg6TELhziJ5c8tk1gtqKod/am0gkZ4497uMQK/76zDFVlTrHoa9V2yUr0K
         hUO6Cw+GH2EkJ5+Bf4wUM24ZEzZJZe75aZtp8rQi1KCIDWFmqqekW3meS3qwrWseat6G
         3gQVxZyxn/uQSw24OcjhvVKqxokTRdu3fECBg3Z4KJaeFiqaGl2vFcNIOi8FZwuUVigH
         H6Sg==
X-Gm-Message-State: ANhLgQ0wccV+qX4fFpFJcYzndjf4EMi5B+1DGU03ojjgK5lr+9yAIMBf
        OvYXiA4tIHAWTrkzz5nLh7uT4SUr
X-Google-Smtp-Source: ADFU+vvvgld/SnrH2iHQAkidbHFB1nHaoZnquYWCj+f/cqwDTeTirkxC4js+fRaysdNbO5Bjc0ITCw==
X-Received: by 2002:a0c:bf05:: with SMTP id m5mr9449810qvi.26.1584049683169;
        Thu, 12 Mar 2020 14:48:03 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id g62sm27623037qkd.25.2020.03.12.14.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:02 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v3 0/9]  Split fsverity-utils into a shared library
Date:   Thu, 12 Mar 2020 17:47:49 -0400
Message-Id: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi,

This is an updated version of my patches to split fsverity-utils into
a shared library. This version addresses most of the comments I
received in the last version:

1) Document the API
2) Verified ran xfstest against the build
3) Make struct fsverity_descriptor private
4) Reviewed (and documented) error codes
5) Improved validation of input parameters, and return error if any
   reserved field is not zero.

I left struct fsverity_hash_alg in the public API, because it adds
useful information to the user, in particular providing the digest
size, and allows the caller to walk the list to obtain the supported
algorithms. The alternative is to introduce a
libverity_get_digest_size() call.

I still need to add some self-tests to the build and deal with the
soname stuff.

Next up is rpm support.

Cheers,
Jes


Jes Sorensen (9):
  Build basic shared library framework
  Change compute_file_measurement() to take a file descriptor as
    argument
  Move fsverity_descriptor definition to libfsverity.h
  Move hash algorithm code to shared library
  Create libfsverity_compute_digest() and adapt cmd_sign to use it
  Introduce libfsverity_sign_digest()
  Validate input arguments to libfsverity_compute_digest()
  Validate input parameters for libfsverity_sign_digest()
  Document API of libfsverity

 Makefile              |  18 +-
 cmd_enable.c          |  11 +-
 cmd_measure.c         |   4 +-
 cmd_sign.c            | 526 +++------------------------------------
 fsverity.c            |  16 +-
 hash_algs.c           |  26 +-
 hash_algs.h           |  27 --
 libfsverity.h         | 127 ++++++++++
 libfsverity_private.h |  33 +++
 libverity.c           | 559 ++++++++++++++++++++++++++++++++++++++++++
 util.h                |   2 +
 11 files changed, 801 insertions(+), 548 deletions(-)
 create mode 100644 libfsverity.h
 create mode 100644 libfsverity_private.h
 create mode 100644 libverity.c

-- 
2.24.1

