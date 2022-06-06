Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E717153EA3E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Jun 2022 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiFFJhz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Jun 2022 05:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiFFJhv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Jun 2022 05:37:51 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA0C165B1
        for <linux-fscrypt@vger.kernel.org>; Mon,  6 Jun 2022 02:37:45 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id r22so4615623ual.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 06 Jun 2022 02:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=zjLlvDwZd1K6KPC2eje+bfKM7A9fSeRVpdGUbtXp0pY=;
        b=qskrGNLmijlE3VraOR1US90QBwIy9E9+Z8yBQlp1xSiJ265pFwkAADS3RvbL4i45ra
         HHUxKVna+U9ql6FPnkJMKplU9nN5xDCvJXHdAslZuVCldRDvthec0f+Y7bL+cMO7xbym
         g3hMk1Zmk/PpeYoJ1xD/7Lj5ws2LHKbjhIdlBulJE5SZ2JZpyiLD6A38kInoF2nV1Wmk
         EpB/NdefNpjtmvEJNGLMrzaB6V1VnuaIvm17hEeiFfs9qu8iU+iZdZAH2W6uHuObyrJf
         /N+D6xqqdr6rr8ouacGTIL8SEwqmu/DBv7Xd785zZa8O8LiCBZGtMvGk2juhXEsqhs+h
         6ELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=zjLlvDwZd1K6KPC2eje+bfKM7A9fSeRVpdGUbtXp0pY=;
        b=hKP9BikLrdjpcvujM2xcsp/fH9uINmiFu2JXlv0Xw5cNnZGKvXwiLOF2mpYC43bAS1
         6N3Pkz3c6+1SJra7EDcMSWN+5TPvSJcq+bKbNOk+m9GVBqG96L+ndf6peP3Mx3c99Owy
         0dZSBQyprK1laJEpAMx2IDshIqUeKf8ay3IfLXQ++hu/gC693o/AuXCFc0AgGfFKHEXy
         xV7t45m+WhD6LnJaen6NSAauDLhu2Caq601PjYosloktiJyGWVrjEN7ydPp7bb2WXo8X
         Bj6oor3pEzMOUWoCJlqrkwf+migz5pcv8K3QJ3H3Efi6coAkM2r8esDhGXOXA5464zqG
         X0yg==
X-Gm-Message-State: AOAM530jKFTiG6cGJirbnaDH4B6ZwMsniQXuzOwiv2a6CAXCJWXvvQbC
        nbH2zY9wxHUPZCJYVo2Hij3oauY9Ep55sDGeMfM=
X-Google-Smtp-Source: ABdhPJwNp2y3WDmaRUaBn1Cwbya2hZ6vqi2ryl6/VK4V9qVV5nIr1rW2bFpi9tCPTpKLOi9Ex77vy9jeyR0fi96MTgI=
X-Received: by 2002:a9f:3109:0:b0:368:c346:6203 with SMTP id
 m9-20020a9f3109000000b00368c3466203mr31494944uab.28.1654508262796; Mon, 06
 Jun 2022 02:37:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:69f:b0:2c7:5acc:3a64 with HTTP; Mon, 6 Jun 2022
 02:37:42 -0700 (PDT)
Reply-To: suzara.wans2021@gmail.com
From:   Mrs Suzara Maling Wan <franckzongo25@gmail.com>
Date:   Mon, 6 Jun 2022 02:37:42 -0700
Message-ID: <CAMWV6wr7LQtbmH25BNYJtG5pL0P_6ORy2uUvGg0ZQdAKHsDnMw@mail.gmail.com>
Subject: Mrs Suzara Maling Wan
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:936 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5018]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [franckzongo25[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [franckzongo25[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [suzara.wans2021[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

My names are Mrs Suzara Maling Wan, I am a Nationality of the Republic
of the Philippine presently base in West Africa B/F, dealing with
exportation of Gold, I was diagnose of blood Causal decease, and my
doctor have announce to me that I have few days to leave due to the
condition of my sickness.

I have a desire to build an orphanage home in your country of which i
cannot execute the project myself due to my present health condition,
I am willing to hand over the project under your care for you to help
me fulfill my dreams and desire of building an orphanage home in your
country.

Reply in you are will to help so that I can direct you to my bank for
the urgent transfer of the fund/money require for the project to your
account as I have already made the fund/money available.

With kind regards
Mrs Suzara Maling Wan
