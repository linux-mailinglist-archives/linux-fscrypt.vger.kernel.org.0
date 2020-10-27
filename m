Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A58029CB13
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Oct 2020 22:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373720AbgJ0VSF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 27 Oct 2020 17:18:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37813 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373460AbgJ0VSE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 27 Oct 2020 17:18:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id w1so3494273wrm.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 27 Oct 2020 14:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xowaxx4EBsMqHNfMng1D9+ESmBC5z5xQFGK0DDXXDl8=;
        b=nDDfRW+a0o9sue4RQyz1BzvsRnRzFiEtUyNXJpMTrducFNenzs3Mw1M82avGTj+57U
         rYqsDohlu5C+b+0hOMOvOSLTQArTCQfetQL5NxXgF+dwb5MRJGw5BfHERj4rbcSVyev+
         eNFB0ITG80VQlXW7E8+LavTj4gXDjNHiWEbUXfpEITLdPj/a5hKlfqLSpStZpmJBLdQ0
         1nVT/UxA7z4P5vJiltuW5g8jAEz18obe8vzFxugdIg7n0LHUSqTdij67b7a/Q0eDY9L6
         B0sOhP90DG9Mg0GO6cZ4PAu9ColhpXgwR/ue1QmOrrgW0ZgwzHTXsr88jwoZCyjkaKHl
         UxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xowaxx4EBsMqHNfMng1D9+ESmBC5z5xQFGK0DDXXDl8=;
        b=pK8G7+3p7oIeeB9NRPkUCFPjGe7Sda3K/qOqSEQDNQvhFAqaHK1sM22QQMpTfxuOl4
         0lTjwhjSyT1MVjStgr5UEvE3YEdtfGfRsWaSW1S4C7lgeLjLNbgH/NI4gjDGIuDGUBNt
         D/bJ86oh6gJQaJSmfsNyfF719xhDuPwbkvF2wls5OirtgM2BPDb0Y93IgFuoyzzCVoQo
         J7OaFlszijldI30/pcCYMBawd3SUUpK2EeXoeAf5cvj2S7Ym24/UJlbPzUyAVdM26A2+
         ay4kD3s91/XrfTbZhcYbSliVEAJ6M3o09fYcyD3FEEwSBf68WEKEI0pA/vduLmC+eOYF
         ZRww==
X-Gm-Message-State: AOAM531PyZjG4xRKanGSKegXGQAaHpQVfe3tjQPcmo+AjYZhSlfeOh91
        Fl9Jva7iAffcV+rrLcVUw5qTzjIpUwSwrNMKa+s=
X-Google-Smtp-Source: ABdhPJw26wCjeyCOvKYG2WtPH18umLKf27V2hubO+XTFEArmOt9rEJkX3D4RTDknjio7DVwFZN7bDLnfYJkeNZS4YR8=
X-Received: by 2002:adf:fd8a:: with SMTP id d10mr4776887wrr.85.1603833482893;
 Tue, 27 Oct 2020 14:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201027191106.2447401-1-ebiggers@kernel.org>
In-Reply-To: <20201027191106.2447401-1-ebiggers@kernel.org>
From:   Luca Boccassi <luca.boccassi@gmail.com>
Date:   Tue, 27 Oct 2020 21:17:51 +0000
Message-ID: <CAMw=ZnRBN989HfGEYCp=O7xLnbeVrKq_s6DkFVfGoVNftP7cCQ@mail.gmail.com>
Subject: Re: [PATCH] fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 27 Oct 2020 at 19:13, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The name "struct fsverity_signed_digest" is causing confusion because it
> isn't actually a signed digest, but rather it's the way that the digest
> is formatted in order to be signed.  Rename it to
> "struct fsverity_formatted_digest" to prevent this confusion.
>
> Also update the struct's comment to clarify that it's specific to the
> built-in signature verification support and isn't a requirement for all
> fs-verity users.
>
> I'll be renaming this struct in fsverity-utils too.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fsverity.rst |  2 +-
>  fs/verity/fsverity_private.h           | 17 ++++++++++++-----
>  fs/verity/signature.c                  |  2 +-
>  3 files changed, 14 insertions(+), 7 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>
