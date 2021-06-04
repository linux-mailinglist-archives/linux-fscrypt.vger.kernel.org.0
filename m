Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D82539BBCA
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 17:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFDP2G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 11:28:06 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:46835 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFDP2F (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 11:28:05 -0400
Received: by mail-il1-f182.google.com with SMTP id v13so9160294ilh.13
        for <linux-fscrypt@vger.kernel.org>; Fri, 04 Jun 2021 08:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AU7V5+c54hD7uJy+lRPqYGW+gRcOyK+yCOwATE4vF7A=;
        b=ZdbbUKNf8Oe0QSkw0CtpnMyOFUw7MoJFdvnhIjXI19jKe07EfCKR5QAASCM4zRkLmS
         TGAkZxHUKt5C3NQDNSN8wWimKyblTuiUgb9W2J1Q9tnSTGQkxsiriIm4VGp9BDF9lgVp
         VJ5FCMAdJNqC13vwoufXByCvbfsdAuwyUOi2DTpf2oqC242+uGmatCMos9IIa7CwCBfj
         DE7iZ+YLLmtRrWrunJ8xB/c57AQAQSoJxg0AJz9PlPy+XEyHyidV3xP/WZUG9x3bINcj
         JNvWnknEs3vKsyjSBJTvaTDiac0I4RzGxZXj6A9rGswPTDvagmzphtvk+Mg++/SE8cU8
         xXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AU7V5+c54hD7uJy+lRPqYGW+gRcOyK+yCOwATE4vF7A=;
        b=fvxXsC9XiaDpn6rhcNnDKdzSRSSQN+MUUfFGvPSiFs0DUL14gAL2/55/jYhlaexkPD
         i5L4uAdoTnEwINXRtSuin7tOYYgEXhnFoefxGaqN2/r+QPkIadg91Z7oUiM0IxUZNpUS
         8/u3dlJVSYWCmrdt03Bs28auF8mDC91Kc9PYXnHDu7jaknwKxo5VsOERYhZKpW9YB/Lg
         G1f/DyJ/Qjc/l2K+KQy/ov90VzWK9rNhfBbsrTXS+6JM5gmVozumVkYVDPzNL+zo/Ym4
         WusBl38r1nSTgSc8zEDK1X6I7lUl/WFk2C/27BF4SR7rWllyHH7WmWb3xsGLp7dNv3mG
         b0ow==
X-Gm-Message-State: AOAM531bryWxMzXSDKv+P4bshRjHoUZT2NQEGkuv140vbV0PganxHkTB
        6m+ybI+TuzxDrpREGT4MMINAukaY3xHK3ID95c3f/w==
X-Google-Smtp-Source: ABdhPJx12NjINhgyYF5viVxupk2w6EYRwIQUgYC4YKEOboSQ6ccjaD8m/4jKwbCaz/MDLgil/9QcbnNcZGVxS9uAWic=
X-Received: by 2002:a92:d3ca:: with SMTP id c10mr4382571ilh.82.1622820318609;
 Fri, 04 Jun 2021 08:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210603195812.50838-1-ebiggers@kernel.org>
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
From:   Victor Hsieh <victorhsieh@google.com>
Date:   Fri, 4 Jun 2021 08:25:07 -0700
Message-ID: <CAFCauYMH_DVNF+CLoC5kpxTb+5uO+Uw9SNGbp=YQsDmXthPPvA@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH 0/4] Add option to write Merkle tree to a file
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Reviewed-by: Victor Hsieh <victorhsieh@google.com>

Thanks Eric!

On Thu, Jun 3, 2021 at 1:00 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Make 'fsverity digest' and 'fsverity sign' support writing the Merkle
> tree and fs-verity descriptor to files, using new options
> '--out-merkle-tree=FILE' and '--out-descriptor=FILE'.
>
> Normally these new options aren't useful, but they can be needed in
> cases where the fs-verity metadata needs to be consumed by something
> other than one of the native Linux kernel implementations of fs-verity.
>
> This is different from 'fsverity dump_metadata' in that
> 'fsverity dump_metadata' only works on a file with fs-verity enabled,
> whereas these new options are for the userspace file digest computation.
>
> Supporting this required adding some optional callbacks to
> libfsverity_compute_digest().
>
> Eric Biggers (4):
>   lib/compute_digest: add callbacks for getting the verity metadata
>   programs/test_compute_digest: test the metadata callbacks
>   programs/utils: add full_pwrite() and preallocate_file()
>   programs/fsverity: add --out-merkle-tree and --out-descriptor options
>
>  include/libfsverity.h          |  46 +++++++++++-
>  lib/compute_digest.c           | 130 +++++++++++++++++++++++++++-----
>  programs/cmd_digest.c          |   7 +-
>  programs/cmd_sign.c            |  17 +++--
>  programs/fsverity.c            |  88 +++++++++++++++++++++-
>  programs/fsverity.h            |   4 +-
>  programs/test_compute_digest.c | 133 +++++++++++++++++++++++++++++++++
>  programs/utils.c               |  59 +++++++++++++++
>  programs/utils.h               |   3 +
>  9 files changed, 458 insertions(+), 29 deletions(-)
>
>
> base-commit: cf8fa5e5a7ac5b3b2dbfcc87e5dbd5f984c2d83a
> --
> 2.31.1
>
