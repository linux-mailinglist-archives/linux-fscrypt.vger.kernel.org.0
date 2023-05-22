Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D685070CE08
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 May 2023 00:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbjEVWfP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 May 2023 18:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjEVWfO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 May 2023 18:35:14 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D13C4
        for <linux-fscrypt@vger.kernel.org>; Mon, 22 May 2023 15:35:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-4d9b2045e1cso1156a12.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 22 May 2023 15:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684794911; x=1687386911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZQp5Oe9OeHBRr4k76BLf3C1RYkjtZNLc9yPRrps/J8=;
        b=bfz6xYrI1eJoYxgHwXKSP3X69QjzDQuMhp79vRPO3P+Bup2yqgP14kDV6qJilGnuwP
         EwLJ48TW+o6bPkJUU3yuzzvHpf4FsZvJSMpstNUdhxLbeijpsYbwQr/FK67Ztu/SsHd6
         PRuvHr8Wm9ZzJITPuBUe8De19Byw+LI5KiGTSm+IwqF3Q/8I1HHRF5LCdmAT7qMAbaIY
         m6j1cQ6TnlRC6ZxTgKfFcv5i7QeQ2k/rqmyXuXYmOPYgz4Ro8sCbRUbTafPW9bnba0Mp
         Gkieo+2MLt6XPTfPcZl9gwD9zDAyhC4M/NjvsZdT2oiTUeR7tLmX4zPZDICRyhP5jWpQ
         buSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684794911; x=1687386911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZQp5Oe9OeHBRr4k76BLf3C1RYkjtZNLc9yPRrps/J8=;
        b=TBaMgM5lsSepgWrHkhjaq39+P6VInLCpi59Z8qql/CWA8IoD13n7mckPcPZERBAuPQ
         FzM679DWwis4HhN1/abL/7aDBGlIHcfHs3aZ0maxtnm+aLNDK3KhfVALkT/E5O0qydtN
         Hcs+O+en5s4owfNdAyMUUMDaAOumh25x4dYYPk3iKQ+fqpjOM5e63H+y4D4z/DCxEUo/
         g+YP8VGpZauBVIGo7Fw3+g9jEf0Jia0uwBdeP7IB1Ni5hiXPJJQpjdoINCcTqxPNoL3G
         nu8z7MqBFboInzSxX4hWJtSQut+e9NRnfNpdz5Bsa8aViswh6fhosj62lzHCgQhEcjnJ
         yXAQ==
X-Gm-Message-State: AC+VfDxme/2jw5Izleo0ynmgMYftZ51nwFuHORsb/2RMKn6bCVrEPLuv
        GnjyAE1IgvukkyKjOXdyC6uuwHH1sAiJq7U658OaUbehlHzjBxCGBA==
X-Google-Smtp-Source: ACHHUZ6GNCd8+uKwST3Jlac+RXt33Mg/1PCldckRwVpcpCB4ek0+WY8z3vxrM7jCBPHLzHlyzHf51QKN2BfmssP08hE=
X-Received: by 2002:a50:870e:0:b0:506:c207:c979 with SMTP id
 i14-20020a50870e000000b00506c207c979mr53730edb.0.1684794911550; Mon, 22 May
 2023 15:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230522213924.never.119-kees@kernel.org>
In-Reply-To: <20230522213924.never.119-kees@kernel.org>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 22 May 2023 15:34:55 -0700
Message-ID: <CAGG=3QVi-j_BLFe23xEqhLhnWA6+aHSGWrsxUSTpGEyTzsFJ0Q@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: Replace 1-element array with flexible array
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 22, 2023 at 2:39=E2=80=AFPM Kees Cook <keescook@chromium.org> w=
rote:
>
> 1-element arrays are deprecated, and are being replaced with C99
> flexible arrays[1]. In the future, we can add annotations for the
> flexible array member "encrypted_path" to have a size determined
> by the "len" member.
>
> As sizes were being calculated with the extra byte intentionally,
> propagate the difference so there is no change in binary output.
>
> [1] https://github.com/KSPP/linux/issues/79
>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-By: Bill Wendling <morbo@google.com>

(With a tear in my eye about the original code...)

> ---
>  fs/crypto/fscrypt_private.h |  2 +-
>  fs/crypto/hooks.c           | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 7ab5a7b7eef8..2d63da48635a 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -171,7 +171,7 @@ fscrypt_policy_flags(const union fscrypt_policy *poli=
cy)
>   */
>  struct fscrypt_symlink_data {
>         __le16 len;
> -       char encrypted_path[1];
> +       char encrypted_path[];
>  } __packed;
>
>  /**
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 9e786ae66a13..6238dbcadcad 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -255,10 +255,10 @@ int fscrypt_prepare_symlink(struct inode *dir, cons=
t char *target,
>          * for now since filesystems will assume it is there and subtract=
 it.
>          */
>         if (!__fscrypt_fname_encrypted_size(policy, len,
> -                                           max_len - sizeof(struct fscry=
pt_symlink_data),
> +                                           max_len - sizeof(struct fscry=
pt_symlink_data) - 1,
>                                             &disk_link->len))
>                 return -ENAMETOOLONG;
> -       disk_link->len +=3D sizeof(struct fscrypt_symlink_data);
> +       disk_link->len +=3D sizeof(struct fscrypt_symlink_data) + 1;
>
>         disk_link->name =3D NULL;
>         return 0;
> @@ -289,7 +289,7 @@ int __fscrypt_encrypt_symlink(struct inode *inode, co=
nst char *target,
>                 if (!sd)
>                         return -ENOMEM;
>         }
> -       ciphertext_len =3D disk_link->len - sizeof(*sd);
> +       ciphertext_len =3D disk_link->len - sizeof(*sd) - 1;
>         sd->len =3D cpu_to_le16(ciphertext_len);
>
>         err =3D fscrypt_fname_encrypt(inode, &iname, sd->encrypted_path,
> @@ -367,7 +367,7 @@ const char *fscrypt_get_symlink(struct inode *inode, =
const void *caddr,
>          * the ciphertext length, even though this is redundant with i_si=
ze.
>          */
>
> -       if (max_size < sizeof(*sd))
> +       if (max_size < sizeof(*sd) + 1)
>                 return ERR_PTR(-EUCLEAN);
>         sd =3D caddr;
>         cstr.name =3D (unsigned char *)sd->encrypted_path;
> @@ -376,7 +376,7 @@ const char *fscrypt_get_symlink(struct inode *inode, =
const void *caddr,
>         if (cstr.len =3D=3D 0)
>                 return ERR_PTR(-EUCLEAN);
>
> -       if (cstr.len + sizeof(*sd) - 1 > max_size)
> +       if (cstr.len + sizeof(*sd) > max_size)
>                 return ERR_PTR(-EUCLEAN);
>
>         err =3D fscrypt_fname_alloc_buffer(cstr.len, &pstr);
> --
> 2.34.1
>
