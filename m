Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF1620E74
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Nov 2022 12:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiKHLSm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Nov 2022 06:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbiKHLSj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Nov 2022 06:18:39 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EE5E004
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Nov 2022 03:18:38 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d123so11160759iof.7
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Nov 2022 03:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1oIX0Lu3jFWZXVxNPQntM2Fj3qbMNn8z1UsbYrWkRo=;
        b=IZj/YP6ZesRfJVOORnCRHdTNx230PLw1QMwGeCuUIkzl0uuo0/wao0dxTvMm3Q4ESE
         VqQlkaR0+elrZdY1r4w2XVZHzkhgtthK5OaF/HwyNK1baWy6FzLTbnkj2OwBEeRnjSbF
         MNy0BgiFIaLatL+6IpaJqbjnAzY3dnh37jk3DMpoGD8TkGsLiJdtAglXdfA7CH8a5HC0
         NkucNnNwMOn7LtDzDoZsaze9MiZFpmne7Qx9HcbmQ+ylYJ0tiyK0Wwt4QoISIMPnPRCy
         fzIPsAnsM6jO3gluisxSK2BjCUW4zjEPfOhAWEm160ScrucrO8Ho8M0EwbbbpZggClPd
         4xog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1oIX0Lu3jFWZXVxNPQntM2Fj3qbMNn8z1UsbYrWkRo=;
        b=UUh12o6CJeOgNs65eAJI2mmvSWgZYCa0PJ5V10sBFKdb0psSA/QEaMGSr7qmEIv8Ti
         V17cvXc0psftqVzlUdvj5h734iV8AK2elPZ/5wZfCQMBZ6usaxJA0SdSN2s+UH+vVBTR
         rP7wLLnaFV2TCR5cW/Yxe0SgEAOYgOQ9QImw6nMN2c+hIpC/I3qrSezKbARLYzF1YfMU
         ce74HPIaKBZhG2/szC9knw6PxaxP2pYer2589muD6FzU5VPt93u2AaTIgdmCH3voztOX
         qouQWCTHh6HcUZ/9BRIJabZijBPGtMPY/Wib/lBqIGawziBZtR+kdvJAwZrqvu86d6rK
         mXUA==
X-Gm-Message-State: ACrzQf1Cqn4vtjlTTcr85Tf45cxfVA7WQ7dFU296nhnJQr5d8m53sAkW
        oPtjDt3S+WG++9XIq5GWnkcwHec4Pz2a22M+c24=
X-Google-Smtp-Source: AMsMyM5Vs/WNPC1zsON0sIvK9PLnW5Nmmg9xW8h8XjSM0RjAGR/ePWNBNsCbV5I81jHMP3HRAvFRyjH9UU+5PJEEZUE=
X-Received: by 2002:a05:6602:13c8:b0:669:c3de:776f with SMTP id
 o8-20020a05660213c800b00669c3de776fmr31194379iov.124.1667906317661; Tue, 08
 Nov 2022 03:18:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6638:38a9:b0:375:4a9b:180d with HTTP; Tue, 8 Nov 2022
 03:18:37 -0800 (PST)
Reply-To: mrinvest1010@gmail.com
From:   "K. A. Mr. Kairi" <ctocik1@gmail.com>
Date:   Tue, 8 Nov 2022 03:18:37 -0800
Message-ID: <CAKfr4JWDjSHVGmqJn8S4S0izNjosxkyb9=MhcnQMfOunFjs1OQ@mail.gmail.com>
Subject: Re: My Response..
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrinvest1010[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ctocik1[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ctocik1[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

-- 
Dear

How are you with your family, I have a serious client, whom will be
interested to invest in your country, I got your Details through the
Investment Network and world Global Business directory.

Let me know, If you are interested for more details.....

Regards,
Andrew
