Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E133F39AF14
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 02:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFDAfR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 20:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAfQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 20:35:16 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C306C06174A
        for <linux-fscrypt@vger.kernel.org>; Thu,  3 Jun 2021 17:33:31 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o21so8230599iow.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 03 Jun 2021 17:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhDOR2wank6wR2VLkc6CF2+7dEj7ptQYNs+9PKOqWzs=;
        b=at6ik2H1xZm+maFq38f0VesybGYvGJtNbVkwghLhbF42lKqEgMxJziD+fubRwt/oa0
         GugrtEtTFM4Usa5il8D+tHvn7u7+NISsdmYeqlShI/0jb2Fucie/B40bgaf7xVVqeNW3
         yGd1eK7lakRgrV+iFNDiWa++HGgYQmXBHY6BmOjB9SVS46cu3XfXZ2Wqxktc6N79WE3A
         ZCdgdNGRS65VIIY6Hs4uapnkdRYdofPt5WMuKEle08+knEX3iRe8dKfGgupXaWO4/Pc3
         XIDX2lZ3IGNDhvqmC2fGXLtfr5zpE79ZPNJplcKckRaJjNPgCZrgh0BSdqcultu348Mg
         zRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhDOR2wank6wR2VLkc6CF2+7dEj7ptQYNs+9PKOqWzs=;
        b=GgJSVi/27bAyfN1Sc4CAxXLnMi4wYoFp61uAn2rV+IyrjyYuxQ6qAOdIm7eIB3xbiU
         oyND2hF71knwXrQD73gItPmqz0P/olEf9iFQpUTirJ+kggEBtraP7K0aQJYkeuqiwqvG
         25n6GjBA3UHq93qHtVcvbTdKi+5UvFbZ4V2itKyJqQvRP8JriaVlvjnT4P2SPJSM/aTD
         eIoXr1rRpolKc70fkNBPIrY18tquk3oR09fmXmoHnUMdjvgE6LA+pCFkUDtQLzLGXV/K
         QlQFu8UTjyEdwzZfTKDWOEE2OnXsYjn6gkqEheY8f3F2Iy8xKdCPbN5g0pJxKbr7EgIO
         t2yQ==
X-Gm-Message-State: AOAM530J661WryYCf+jXLDJkEcTn+kn1vzPl8khm7uJ7SjVLZL4liFhe
        b6f2SUrUNcGZ+51bHjk8NpJcBSZnSnCZHI8rldgGtpVNPQU=
X-Google-Smtp-Source: ABdhPJz+VVOZQ/gs+lSO/Wd0YDLMgw665s/bM9qngsygIVEDW2eTlar/0nmEVSws55gmLm9mhAkv/Nfp0skw0I5BdOc=
X-Received: by 2002:a05:6638:32a8:: with SMTP id f40mr1536734jav.84.1622766809627;
 Thu, 03 Jun 2021 17:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210603195812.50838-1-ebiggers@kernel.org> <20210603195812.50838-4-ebiggers@kernel.org>
In-Reply-To: <20210603195812.50838-4-ebiggers@kernel.org>
From:   Victor Hsieh <victorhsieh@google.com>
Date:   Thu, 3 Jun 2021 17:33:18 -0700
Message-ID: <CAFCauYO9Hrg-jjNzfMwruU4BQTOD5dFbPnASJXPRKdCQH5tETw@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH 3/4] programs/utils: add full_pwrite() and preallocate_file()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 3, 2021 at 1:00 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> These helper functions will be used by the implementation of the
> --out-merkle-tree option for 'fsverity digest' and 'fsverity sign'.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  programs/utils.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
>  programs/utils.h |  3 +++
>  2 files changed, 62 insertions(+)
>
> diff --git a/programs/utils.c b/programs/utils.c
> index ce19b57..116eb95 100644
> --- a/programs/utils.c
> +++ b/programs/utils.c
> @@ -13,10 +13,14 @@
>
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <inttypes.h>
>  #include <limits.h>
>  #include <stdarg.h>
>  #include <sys/stat.h>
>  #include <unistd.h>
> +#ifdef _WIN32
> +#  include <windows.h>
> +#endif
>
>  /* ========== Memory allocation ========== */
>
> @@ -126,6 +130,26 @@ bool get_file_size(struct filedes *file, u64 *size_ret)
>         return true;
>  }
>
> +bool preallocate_file(struct filedes *file, u64 size)
> +{
> +       int res;
> +
> +       if (size == 0)
> +               return true;
> +#ifdef _WIN32
> +       /* Not exactly the same as posix_fallocate(), but good enough... */
> +       res = _chsize_s(file->fd, size);
> +#else
> +       res = posix_fallocate(file->fd, 0, size);
> +#endif
> +       if (res != 0) {
> +               error_msg_errno("preallocating %" PRIu64 "-byte file '%s'",
> +                               size, file->name);
> +               return false;
> +       }
> +       return true;
> +}
> +
>  bool full_read(struct filedes *file, void *buf, size_t count)
>  {
>         while (count) {
> @@ -160,6 +184,41 @@ bool full_write(struct filedes *file, const void *buf, size_t count)
>         return true;
>  }
>
> +static int raw_pwrite(int fd, const void *buf, int count, u64 offset)
> +{
> +#ifdef _WIN32
> +       HANDLE h = (HANDLE)_get_osfhandle(fd);
> +       OVERLAPPED pos = { .Offset = offset, .OffsetHigh = offset >> 32 };
> +       DWORD written = 0;
> +
> +       /* Not exactly the same as pwrite(), but good enough... */
> +       if (!WriteFile(h, buf, count, &written, &pos)) {
> +               errno = EIO;
> +               return -1;
> +       }
> +       return written;
> +#else
> +       return pwrite(fd, buf, count, offset);
> +#endif
> +}
> +
> +bool full_pwrite(struct filedes *file, const void *buf, size_t count,
> +                u64 offset)
> +{
> +       while (count) {
> +               int n = raw_pwrite(file->fd, buf, min(count, INT_MAX), offset);
> +
> +               if (n < 0) {
> +                       error_msg_errno("writing to '%s'", file->name);
> +                       return false;
> +               }
> +               buf += n;
I think this pointer arithmetic is not portable?  Consider changing
the type of buf to "const char*".

> +               count -= n;
> +               offset += n;
> +       }
> +       return true;
> +}
> +
>  bool filedes_close(struct filedes *file)
>  {
>         int res;
> diff --git a/programs/utils.h b/programs/utils.h
> index ab5005f..9a5c97a 100644
> --- a/programs/utils.h
> +++ b/programs/utils.h
> @@ -40,8 +40,11 @@ struct filedes {
>
>  bool open_file(struct filedes *file, const char *filename, int flags, int mode);
>  bool get_file_size(struct filedes *file, u64 *size_ret);
> +bool preallocate_file(struct filedes *file, u64 size);
>  bool full_read(struct filedes *file, void *buf, size_t count);
>  bool full_write(struct filedes *file, const void *buf, size_t count);
> +bool full_pwrite(struct filedes *file, const void *buf, size_t count,
> +                u64 offset);
>  bool filedes_close(struct filedes *file);
>  int read_callback(void *file, void *buf, size_t count);
>
> --
> 2.31.1
>
