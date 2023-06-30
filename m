Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32877433B9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 06:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjF3Epj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 00:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjF3Epi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 00:45:38 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88CF2118;
        Thu, 29 Jun 2023 21:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688100197; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=PZP6GR6XyvR4JOR6xXLruJf7U2QaWCAiYJVe4SwxDx4=; b=ke7Sb1DSwpOtg8xjStsNmBdNSxID+K4HQmOdeQLNsB7dbXQm5VX7l59tVWx6bfdvJPuujXlxmjvKoVX6EL0QcTMkRSIVgGRv8PSXn7E3NcCcuprAGBlUV0NFPY23g+vbEvxO6EX/4eu4DCWmlGJGS60JnEIZssiEHCMp09wH2DY5W5XiJsbfFA9UkUh/2hcQ9wLWN35RQui4ZsQcNoIiFVSYSV7hq31mUmawTziXrGo6TGFTPOL+VUZtqcTWPfORlj4hE3PayNQ/58ouwh+jbaiXb4DHesz03RcAxl3k3DjBnRuTOmWqZPu04akUVnzGPxu4lt3X535aw0sEVORfjA==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 30 Jun 2023 13:43:02 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 506;
          Fri, 30 Jun 2023 13:45:09 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     'Eric Biggers' <ebiggers@kernel.org>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jens Axboe' <axboe@kernel.dk>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230626084703.907331-1-letrhee@nsr.re.kr> <20230626084703.907331-5-letrhee@nsr.re.kr> <20230628063830.GA7920@sol.localdomain> <000901d9aa70$a228c420$e67a4c60$@nsr.re.kr> <20230630025914.GB1088@sol.localdomain>
In-Reply-To: <20230630025914.GB1088@sol.localdomain>
Subject: RE: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date:   Fri, 30 Jun 2023 13:45:10 +0900
Message-ID: <001201d9ab0d$a6ab50b0$f401f210$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHHxDRlmstc7qqNSJFY4M8BkkyX4gFqzZG4AcdR3rkCVVeuvQFbPgFSr497xkA=
Content-Language: ko
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 29, 2023 at 19:59:14 -0700, Eric Biggers wrote:
> I don't think that really addresses my comment, due to the second
sentence.  I
> understand that you would like to advertise the performance of LEA.  But
as I
> mentioned, it's not yet realized in the kernel crypto API, and in the
context of
> fscrypt it won't really bring anything new to the table anyway.  For now I
think
> LEA is best described as a "national pride cipher" alongside SM4...  Keep
in
> mind, it can always be changed later if new use cases come up.
> 
> Could you just omit the documentation update from your patch?  I actually
need
> to rework the whole "Encryption modes and usage" section anyway since it's
> growing a bit unwieldy, with 6 different combinations of encryption modes
now
> supported.  The information needs to be organized better.  It currently
reads
> like a list, and it might be hard for users to understand which setting to
use.
> 
> I'll add on a patch that does that and adds the mention of LEA support.
> 
> - Eric

Thanks for the feedback.

We'll remove the documentation and submit the next version.
