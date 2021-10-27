Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B317143C6A3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Oct 2021 11:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbhJ0Jou (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Oct 2021 05:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhJ0Jou (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Oct 2021 05:44:50 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E62CC061348
        for <linux-fscrypt@vger.kernel.org>; Wed, 27 Oct 2021 02:42:25 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id gh1so1342554qvb.8
        for <linux-fscrypt@vger.kernel.org>; Wed, 27 Oct 2021 02:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VWxEs5WjHGJZV9rZ2I4DPQ44YOYFkrn8z8UBcYgDlP8=;
        b=LLtYLqL1fqVuBxbDKjF+C2QckUpyc6ZkHFOvEXWAvybUAfbVEQuQkhIVVECWMDIbt4
         OBFzC/n7q03wtKzYMeoHZwb3IfMfXKcNwWm1FWIlF1/iRjQDasl4hSwCDeeqV1U+zT6K
         PbaJ80vAPnqx3oSJ3a289gEJ2qkF2MZCYwJVkKQ0r5wHhmttoWPmzjRuy979MHNl3UXL
         yHEafwAJFlPmQFD4W6F+r9f1MvuHxd3VUPZ2QgWJRC33BeQ1XTnLyIQ9TlFPtz6DnixH
         AF0IRknQPscD5P2+IFAxOZKGp5piL0FqJl4yYFJY3eg4ye3Xq4rcQbL/u1dxie8myTf3
         Foqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=VWxEs5WjHGJZV9rZ2I4DPQ44YOYFkrn8z8UBcYgDlP8=;
        b=2DBNUvtGqhTSsrebr5RPs014ZQ7Ll1DdD1lSBt1eJqQqDhPUXOKfhE4eEjRzHLUe/B
         TB+LL/JSH3y3PkHwY84Xe4w1w2A3qGbi3+KAOEVb9s9SRDikjdRYnn7RbpDFvUTLzUMv
         ON6mHoJTCQ4A5gnzaTKIqYzwP9kHYr15tXbu85gtRr/FpZyaQnZrSqWnjGC3rikegIv6
         q/JoA0HdW1WOvL6WUXwtcEjYPE9AJSr7rp2iWcU+cp9njxJwPmC0ET1a2Vc/hUyNGSFm
         DDujZ8aBJQKaG0hTP1LA5w5MzKsurABxfxo8CVhr3NowCemS5MbtkSoJYx62HqkF1yS4
         f33g==
X-Gm-Message-State: AOAM532Zm9E+f9KXi/EBTaPIXhG74egqB0HTbWcYtwWewuQ7bK34t+xi
        F71WjNqXguryCVW48YyHqcSsLvYdUYsXQaZHnCc=
X-Google-Smtp-Source: ABdhPJykO0w8ItQQ1vF1L+KU40GSxoptlME/JSAO8ZWMQukqUQID2ibN/CkrcviQOUT8WiE36y74cU3Bc/rxvnfn/2A=
X-Received: by 2002:a05:6214:21a5:: with SMTP id t5mr20402545qvc.35.1635327744327;
 Wed, 27 Oct 2021 02:42:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:27e5:0:0:0:0 with HTTP; Wed, 27 Oct 2021 02:42:24
 -0700 (PDT)
Reply-To: jackpotcharityclaims@gmail.com
From:   Charles W Jackson Jr <jannetrobert12@gmail.com>
Date:   Wed, 27 Oct 2021 10:42:24 +0100
Message-ID: <CAEpoZdeTVJmZLPr8_sU101VJhfJPNyBS_ugvksGAtGkCJe9tVg@mail.gmail.com>
Subject: =?UTF-8?Q?Gemeinn=C3=BCtzige_Anspr=C3=BCche?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=20
Ich bin Charles W Jackson Jr., der Gewinner der Powerball-Lotterie von
344 Millionen Dollar. Ich spende 3,5 Millionen US-Dollar im Namen
meiner Familie, um 10 Menschen und kleinen Unternehmen zu helfen.
Kontaktieren Sie mich =C3=BCber
E-Mail: jackpotcharityclaims@gmail.com f=C3=BCr weitere Details.
