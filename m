Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E36529D33A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Oct 2020 22:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgJ1VmA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Oct 2020 17:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgJ1Vl6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Oct 2020 17:41:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23CEC0613CF
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:41:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c16so658244wmd.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=la9jtBLRXJROpZoCyLPSmSjSnPtjmvLqvY2RSdsKJR8=;
        b=ZETeU5nH2Vdsmzjl1psRLRiSPLsbCHIg1FWWLN3MKVyZp9C8HjfOPRS7P2Q2HlWdIU
         4dwSkNCs5FKTSx4XL/iuATQi5WnH+T4th6zSCGbaQ/csaDv/AToYayB7A+JUzCxfkYgz
         Y9Lu/iVCKNbO9syG4AkwhqisB6vHJiyOEqKglCl3BB5muzFD3MCfZIrDgqcpkA0+MwX0
         eLsuEsoK0JjtvW4hYTEVe2KQr8agCLMAtQTPqXw6d5W1iwvQSUohvfn5tB1ztyNpMiFN
         2tioMFqcDXNj6AdVvOjrO5bqQsF3fEvwNEdwYSOOIuNLvnvBtU9AMZUrKEj97FAfU3OJ
         KE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=la9jtBLRXJROpZoCyLPSmSjSnPtjmvLqvY2RSdsKJR8=;
        b=JwOpBwSo0mdflb07NR+Ik33FDPqPziVOY0zyJNz00JSc+Emk+HMvzXVTlGZ4qwoSqF
         oHccE72punEfj0FS7FY08eLUlj12+vY5990eIabugWYsSE7s3ns3kMdiTRAdbKWiU9bv
         k1UZa2aBYzOIAISBbAOfAzSJpJsTmA0HrR8LfYasm4LSf21MqOPOpVGgKsiCyP9AtlPa
         pOv/sQHlbhYEhRVX/wxGyd0SP4pt6YRxeWKhvGEE7a8nE9WRLkkUg4NkU6u844Vanfyv
         cE+1ql+ln135gIGn5frLRz9vV5mtJw97eGWcQwsYxc9qz+PcLjeMeRdr9/HiCxKR2RZB
         ZaIQ==
X-Gm-Message-State: AOAM531EyE6HcVKoam4SUQ9zcnjHMkPxioyoejnG7dyU7XJsdiYQe0Hw
        LEoKJcACYJT5F/Gnj0Ebew6XiL2csgmfQzHpxgoYIPjfvDvZVQ==
X-Google-Smtp-Source: ABdhPJyACiY/mk4FkhDIW9MdnMSCmjavIO9PHlkr35SIG5EU0jKEyFb6Pg2KtNeSOw6fH9WVf7as53kZ/jYY1qjh1go=
X-Received: by 2002:a05:600c:216:: with SMTP id 22mr105809wmi.149.1603910310296;
 Wed, 28 Oct 2020 11:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <5339059d53b26837d1b90217ec21eb0d99e938ad.camel@gmail.com> <20201028182716.154790-1-ebiggers@kernel.org>
In-Reply-To: <20201028182716.154790-1-ebiggers@kernel.org>
From:   Luca Boccassi <luca.boccassi@gmail.com>
Date:   Wed, 28 Oct 2020 18:38:19 +0000
Message-ID: <CAMw=ZnQZTrgVCu5sE0HeDBS+egw7kyQ3+U6cY56DMRxDUTkVVQ@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH] Makefile: adjust CFLAGS overriding
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 28 Oct 2020 at 18:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Make any user-specified CFLAGS only replace flags that affect the
> resulting binary.  Currently that means just "-O2".  Always add the
> warning flags, although they can still be disabled by -Wno-*.  This
> seems to be closer to what people want; see the discussion at
> https://lkml.kernel.org/linux-fscrypt/20201026204831.3337360-1-luca.boccassi@gmail.com/T/#u
>
> Also fix up scripts/run-tests.sh to use appropriate CFLAGS.  That is,
> don't specify -Wall since the Makefile now adds it, always specify
> -Werror, and usually specify an optimization level too.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Makefile             |  7 ++++--
>  scripts/run-tests.sh | 54 ++++++++++++++++++++++----------------------
>  2 files changed, 32 insertions(+), 29 deletions(-)

Acked-by: Luca Boccassi <bluca@debian.org>
