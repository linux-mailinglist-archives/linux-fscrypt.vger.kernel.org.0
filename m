Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DA43AC86
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 09:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhJZHDf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 03:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhJZHDc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 03:03:32 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3375FC061745;
        Tue, 26 Oct 2021 00:01:09 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i65so31608560ybb.2;
        Tue, 26 Oct 2021 00:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Soe5NNeWWT4YqZSv3BbvDOunOwTW9p4OJyY5KoVOAk=;
        b=RRmEH6M6E7fbroqnQ+QelBZC2s+Srnoeo1IzSfVaoc/c0u674nZcByIXLWvWEgGvqb
         oqZcivUhACtLf//P5Iwed3IM0NHLj0Z5jYlEi/WfcaxUaybNsQLvqPt7schP+F6+TrTC
         n3lRHgIehlzhQDKR8VhRvZDKfbknH/M0TMPnKLGtKYlr+yOkEsAwQVxg5P8NbdXcI0Bv
         n1rU12g8ckyWA1AtDZE4VlxBk98joetX3ckc1Mni5KT4k+/fxEpD3jSJu5fQmrZ1ebOe
         JzZWxGMrC6716NQufSPUCLfUTzDY0LUl8q/NDCExnGXiMgy/JUl6uSgjct7UpEs8DQXy
         DLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Soe5NNeWWT4YqZSv3BbvDOunOwTW9p4OJyY5KoVOAk=;
        b=lcZNMFRLCsbvTr5cxtkoliGJKyaNZkTLGlfMtEsYyZZ3GgDw/M5oZ6iRV2etrT0mry
         FAlfYHhhQ33mCYkrnTDJS2wRg/K8EstwrLSiDDPTn3n5Ask1evmNczzop+q5mQpHOTuY
         oh8nbaBtKwF+FiKuQd6U6jIxnVKyjsYavUn0pEdMmlSkrgXfzK0TAOEdIQ8fwMxA5ydV
         TG8ft1PazgV0wrsXBUiQkxpMgnN++leVCo0o26mwxWDVxu8lUuzO0LEqmrSwu2fy5Fn4
         ixe3r/oXdESRM8QEwH1ntMqtGBfnTRvXXWj6E9g4qS/xHj+mPoju4lvu8sIO5L+rF5zv
         152g==
X-Gm-Message-State: AOAM532vUfVBVgEOEsbfivvKtZ0XS1IXR2XJ03h5Jds7yDr36IA+GFtU
        oJphZCvYlIQ8m9jfVoeSX7MH7NrPjGtBP+DjBKo=
X-Google-Smtp-Source: ABdhPJx1O6mRHHqysnVqQuwopGFTGidseAy/Qvt4a+wUM/iOaIYOFgbqL0h0jmwLBLIDmycFi9VFkQxXZkFFCeyMPi0=
X-Received: by 2002:a25:5545:: with SMTP id j66mr21847070ybb.288.1635231668385;
 Tue, 26 Oct 2021 00:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <YXGyq+buM79A1S0L@relinquished.localdomain> <YXcKX3iNmqlGsdzv@gmail.com>
In-Reply-To: <YXcKX3iNmqlGsdzv@gmail.com>
From:   Vadim Akimov <lvd.mhm@gmail.com>
Date:   Tue, 26 Oct 2021 10:00:52 +0300
Message-ID: <CAMnT83ssLEy+pO3t35EDHCZucC2bJZqy-0EfvsocFNqaGgXMog@mail.gmail.com>
Subject: Re: Btrfs Fscrypt Design Document
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 25 Oct 2021 at 22:59, Eric Biggers <ebiggers@kernel.org> wrote:

> However,
> given that btrfs is a copy-on-write filesystem and thus can support per-block
> metadata, a natural question is why not support an authenticated mode such as
> AES-GCM, with a nonce and authentication tag stored per block?  Have you thought
> about this?

Can't the existing checksum fields be just reused to keep HMACs? This
way even the unencrypted metadata could be authenticated.
