Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E964E31BB63
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Feb 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBOOup (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Feb 2021 09:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBOOuo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Feb 2021 09:50:44 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC66C061756
        for <linux-fscrypt@vger.kernel.org>; Mon, 15 Feb 2021 06:50:04 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id y35so2459113uad.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 15 Feb 2021 06:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GO6qWVWGkNVy6PcyJKZAktMxSp7M9BtyFH1r4gIztmI=;
        b=pT5dUqvLqx2H9hcZ4RQFXFpT5ZWpORoTM2mK5iJwVfkierXjEW6A3U0jKVrJPBiPpj
         w7RYfTz3E0zsuvn/jnYqmaW0Bw6dYpBqiYYegeIsEzJx/9Ux/kErgoQlO7N95FmJ+3gf
         7s6OPEBwN7h+BMVMlpoQoxcryMaunZXFZbcCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GO6qWVWGkNVy6PcyJKZAktMxSp7M9BtyFH1r4gIztmI=;
        b=HmIXuf7SPDkvlMaLEh/DYTPSH+FVV1NhD1AV/iqzPQCF0sIuTC1y2wMtP9ut6QbFzS
         dmNR+JKHT7+0mfxrD8EXQEWWV6qLmckHf+udocSI7Y+Yacsnfqa/Td7O71wo4JoFUnwY
         r4999IQkYk4TeT4aE/DxfA6kO0wrzlCBNrQHGKs/fJnXg6uRLWhmWWmkKH/TBgqTUHVs
         GJACGLb8NJjQKOu4vcEeU5cM/brgfsXKYyEFMyAPQEk3hTKWE4IwKItwj47ncQwuZPST
         un8UF9bSrfSEk+sGQkzJHBxs4+tAwwSzQJhG0WbMMRGbBv8hHTATiEEhGaisEekGRSxf
         zbNQ==
X-Gm-Message-State: AOAM531FBGRepmtex/FHKvMBReNpZ99YDk0icL8L56pwZFfio8SaKUeC
        0GJUZrRCi5jiN4N9ktyMA1lxSXuD558IyM5uafWnIA==
X-Google-Smtp-Source: ABdhPJxHPZstJtZvarT0N3o2doLRe5vhZC5hvyxuxJV276tNk6aRNh5MNi+LTm4WCs5EEMZHlGVcbJq204upVafP9jQ=
X-Received: by 2002:ab0:3c91:: with SMTP id a17mr9514794uax.9.1613400603278;
 Mon, 15 Feb 2021 06:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20201207040303.906100-1-chirantan@chromium.org>
 <20201208093808.1572227-1-chirantan@chromium.org> <20201208093808.1572227-3-chirantan@chromium.org>
In-Reply-To: <20201208093808.1572227-3-chirantan@chromium.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 15 Feb 2021 15:49:52 +0100
Message-ID: <CAJfpegtq1fDapizFX3idgrYd3dahtiZ-32F8bvoEMZwGdD43hQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fuse: Support FS_IOC_GET_ENCRYPTION_POLICY_EX
To:     Chirantan Ekbote <chirantan@chromium.org>
Cc:     linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Suleiman Souhlal <suleiman@chromium.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 8, 2020 at 10:38 AM Chirantan Ekbote <chirantan@chromium.org> wrote:
>
> Chrome OS would like to support this ioctl when passed through the fuse
> driver. However since it is dynamically sized, we can't rely on the
> length encoded in the command.  Instead check the `policy_size` field of
> the user provided parameter to get the max length of the data returned
> by the server.

I'd also maximize the length at sizeof(union fscrypt_policy).  I.e.
virtiofs doesn't need to support higher level versions than the client
kernel supports.

Also, I'm thinking about whether it's safe to enable in plain fuse in
addition to virtiofs.  I don't see a reason for not doing so, but
maybe it makes sense to keep disabled until a use case comes up.

Thanks,
Miklos


>
> Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> ---
>  fs/fuse/file.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 69cffb77a0b25..b64ff7f2fe4dd 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -19,6 +19,7 @@
>  #include <linux/falloc.h>
>  #include <linux/uio.h>
>  #include <linux/fs.h>
> +#include <linux/fscrypt.h>
>
>  static struct page **fuse_pages_alloc(unsigned int npages, gfp_t flags,
>                                       struct fuse_page_desc **desc)
> @@ -2710,6 +2711,21 @@ static int fuse_get_ioctl_len(unsigned int cmd, unsigned long arg, size_t *len)
>         case FS_IOC_SETFLAGS:
>                 *len = sizeof(int);
>                 break;
> +       case FS_IOC_GET_ENCRYPTION_POLICY_EX: {
> +               __u64 policy_size;
> +               struct fscrypt_get_policy_ex_arg __user *uarg =
> +                       (struct fscrypt_get_policy_ex_arg __user *)arg;
> +
> +               if (copy_from_user(&policy_size, &uarg->policy_size,
> +                                  sizeof(policy_size)))
> +                       return -EFAULT;
> +
> +               if (policy_size > SIZE_MAX - sizeof(policy_size))
> +                       return -EINVAL;
> +
> +               *len = sizeof(policy_size) + policy_size;
> +               break;
> +       }
>         default:
>                 *len = _IOC_SIZE(cmd);
>                 break;
> --
> 2.29.2.576.ga3fc446d84-goog
>
