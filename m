Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AFD1B812F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgDXUzI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgDXUzH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:07 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9521BC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:07 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t3so11726263qkg.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wj9EhYRPwOztWTDwOurfrtyYX9902xOHLVL8Qeab6NU=;
        b=Jsd0WnFMUbKzsunoiO6OoivS/D2VStwefQu8C5IEYBKwEPWeVToLo+3D5pyEI4aY3Y
         Rf4Vs0BABy3yNCx136Q97sdjrqKOg852XA5H5sI0aYdxu/Ny/5mdcK0mRrfP673h2+wv
         8C2RrfbpJ6TuBivYZhuqoI6j0ZeZyWI9QrTYaUxaXZ6vDogWI1xabj2ouQ7ByflvuFVh
         MJsvODF+nfKvcp9WqInHOLGLIbR8lh9MQx+Z8GvG2hZGGmVICp+WDe9tr0y7jjy+BWVz
         DRF2xN1isAGSftWzbVtjKgRzIRQ1ovn4T3sNuSSelCFgAiAZUMmD+ygSOEG50kTqlmQ9
         LK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wj9EhYRPwOztWTDwOurfrtyYX9902xOHLVL8Qeab6NU=;
        b=llw3xJTV9YnawsoK1+ZN2HvgGCoL/97jP9+XqUJJaCx0ir/a8aWC0fk7ZzGgAOWWzC
         Ia6OO5BMbnoGE+nW8ZUBx/IE51JyC2z85C/uU+ZG0r80IqInTdEhIUUeE7jjrNQ78ROh
         lBqCkeaWSgUOBFTDzFUv9oOvfBX3dMugnEZJ80QBSgVonOrG0KP5q6IBGXGdaDb26z0L
         9dWhwm97TShsF/XfVOTXntn4LqDFHzxWVPRSRESFRdxvwCWskPaZ+QpKuqPt18/wP+gY
         07YBhTljqW49JvLKG+WBVRcgyvfq1sdTjejIvrCMgM72X/3dKn6opHpTtyijcMrH30cB
         YNYQ==
X-Gm-Message-State: AGi0PuZlmsE3hrH0PUSEx3IEC+LqiFVa0sHfg1bsz2aAaK8i+jaW6q1K
        6newunvK1UxtLKpVzyCwXLXXwNISDKs=
X-Google-Smtp-Source: APiQypLZ6awGbsXrftpVmnFE/DtrQcOnu6OsVfbhn6ozNz8xTg5ikxjHPyjprJ+jxC7mG9Asb43iHQ==
X-Received: by 2002:ae9:e011:: with SMTP id m17mr11280881qkk.103.1587761706255;
        Fri, 24 Apr 2020 13:55:06 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id a27sm4918797qtb.26.2020.04.24.13.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:05 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH v4 00/20] Split fsverity-utils into a shared library
Date:   Fri, 24 Apr 2020 16:54:44 -0400
Message-Id: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi

This is an update to the libfsverity patches I posted about a month
ago, which I believe address all the issues in the feedback I received.

I have a version of rpm that requires this library which is able to
sign files and a plugin which will install fsverity signatures when
the rpm is installed. The code for rpm can be found on github - note
that I do rebase the repo as I fix bugs:
https://github.com/jessorensen/rpm/tree/rpm-fsverity

A git tree with these patches can also be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/jes/fsverity-utils.git

This update changes a number of issues:
- Change the API for libfsverity_compute_digest() to take a callback
  read function, which is needed to deal with the internal cpio
  processing of rpm.
- Provides the option to build fsverity linked statically against
  libfsverity
- Makefile support to install libfsverity.so, libfsverity.h and sets
  the soname
- Make struct fsverity_descriptor and struct fsverity_hash_alg
  internal to the library
- Improved documentation of the API in libfsverity.h

I have a .spec file for it that packages this into an rpm for Fedora,
as well as a packaged version of rpm with fsverity support in it,
which I am happy to share.

Let me know what you think!

Thanks,
Jes


Jes Sorensen (20):
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
  Change libfsverity_compute_digest() to take a read function
  Make full_{read,write}() return proper error codes instead of bool
  libfsverity: Remove dependencies on util.c
  Update Makefile to install libfsverity and fsverity.h
  Change libfsverity_find_hash_alg_by_name() to return the alg number
  Make libfsverity_find_hash_alg_by_name() private to the shared library
  libfsverity_sign_digest() use ARRAY_SIZE()
  fsverity_cmd_sign() use sizeof() input argument instead of struct
  fsverity_cmd_sign() don't exit on error without closing file
    descriptor
  Improve documentation of libfsverity.h API
  Fixup Makefile

 Makefile              |  49 +++-
 cmd_enable.c          |  19 +-
 cmd_measure.c         |  19 +-
 cmd_sign.c            | 565 +++++------------------------------------
 fsverity.c            |  17 +-
 hash_algs.c           |  95 ++++---
 hash_algs.h           |  36 +--
 helpers.h             |  43 ++++
 libfsverity.h         | 138 ++++++++++
 libfsverity_private.h |  52 ++++
 libverity.c           | 572 ++++++++++++++++++++++++++++++++++++++++++
 util.c                |  15 +-
 util.h                |  62 +----
 13 files changed, 1029 insertions(+), 653 deletions(-)
 create mode 100644 helpers.h
 create mode 100644 libfsverity.h
 create mode 100644 libfsverity_private.h
 create mode 100644 libverity.c

-- 
2.25.3

