Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25B2273A9F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Sep 2020 08:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgIVGS3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Sep 2020 02:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729223AbgIVGS3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Sep 2020 02:18:29 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08A2C0613D1
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Sep 2020 23:18:28 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id 4so3863066ooh.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Sep 2020 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=THG6vXPDgMK2k7M4yyjWTbzR9oGicsRPw9gT2Zgg6Sk=;
        b=Qd4Tdn1whmgSMaYeHJVAjI8lu/OUqAsaY6nMEildJ5Wcz+HOxT7jXMUD03tm9yR8G/
         vDzyb+d1lGxQNLYIXQnFVhKqaG73yC0TaoNUjzC++ozwpShucs6pqMzhnsZxjr1Nzb4h
         K1wCeilU3Fa+351ZL8SHv8tnUER/5ayy20tGJ+Jy3mcBP4iSlxPb6pgoN1jPd4Q3Eeam
         ayKBIA93D2dJaa8PMAJ4fCf08YI7Tow7I09AS1hKl6PGi/YEqKRGKJf0D0x+YgzKHRdo
         /qbO9M29ylVanv5qWiyLs/g4pHmvhvUZPxJXOAOkBlwa6w0235QHuMaIfR4oJF8EDJME
         vaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=THG6vXPDgMK2k7M4yyjWTbzR9oGicsRPw9gT2Zgg6Sk=;
        b=i8or7F8rgu2CgFbBBVXAZDpSFS/2JlxMwN8jqUqzP3jaPxpslw0O0GzaF+qCqlkUAt
         9Dk8YQ4jZy0AETG1pmcE/TMGrT5es8JrdDPqmG5bam7NE7b+A63CTKoCqJpb7V/05B8C
         sQ316huxij4+yJod/D+iYMIXitF0gJbl1/f8rC0Fj+9UjVo6znHPPmzpfVtWav42Cyer
         GoemuddbBMiepqMxEJJ91yBvmgKtpGC0FkuOmIW6LSPLluwQSh8QDDEf0yrxh3BBjIJt
         DSU/GTrCqutfdkCFhw1RXkGeX03KIkR1bGI0VTtDUHF8UFbzkLd3RQpFzXQJWkKVzZbB
         kdPg==
X-Gm-Message-State: AOAM533dBBZMaUWZO5XTWqgzMl0/qo1CXxfocnRHoQ2nQa1zR6NJ+Qcp
        OkUlEqrDMNjvcHEEuzd3ZBS7VFAOnhO5UmmWNwen0g==
X-Google-Smtp-Source: ABdhPJwiYGOeLvLhGoogpy5gPNwnvC+JJiMwI4f1hoq32kpb9NOx05Ev2dELtbD9Mb/3dVl5K4CX6bx+/hBa8I6MKSY=
X-Received: by 2002:a4a:5258:: with SMTP id d85mr1950472oob.72.1600755507994;
 Mon, 21 Sep 2020 23:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200708091237.3922153-1-drosen@google.com> <20200708091237.3922153-5-drosen@google.com>
 <87lfh4djdq.fsf@collabora.com> <20200921182948.GA885472@gmail.com>
In-Reply-To: <20200921182948.GA885472@gmail.com>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Mon, 21 Sep 2020 23:18:17 -0700
Message-ID: <CA+PiJmQU-bupmSTHbW2MPzDxfO+3f2bu+7aKzBL1VF2D8mvqZQ@mail.gmail.com>
Subject: Re: [PATCH v12 4/4] ext4: Use generic casefolding support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 21, 2020 at 11:29 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Sep 20, 2020 at 09:10:57PM -0400, Gabriel Krisman Bertazi wrote:
> > Daniel Rosenberg <drosen@google.com> writes:
> >
> > > This switches ext4 over to the generic support provided in
> > > the previous patch.
> > >
> > > Since casefolded dentries behave the same in ext4 and f2fs, we decrease
> > > the maintenance burden by unifying them, and any optimizations will
> > > immediately apply to both.
> > >
> > > Signed-off-by: Daniel Rosenberg <drosen@google.com>
> > > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > >
> > >  #ifdef CONFIG_UNICODE
> > > -   if (EXT4_SB(parent->i_sb)->s_encoding && IS_CASEFOLDED(parent)) {
> > > +   if (parent->i_sb->s_encoding && IS_CASEFOLDED(parent)) {
> > >             if (fname->cf_name.name) {
> > >                     struct qstr cf = {.name = fname->cf_name.name,
> > >                                       .len = fname->cf_name.len};
> > > @@ -2171,9 +2171,6 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> > >     struct buffer_head *bh = NULL;
> > >     struct ext4_dir_entry_2 *de;
> > >     struct super_block *sb;
> > > -#ifdef CONFIG_UNICODE
> > > -   struct ext4_sb_info *sbi;
> > > -#endif
> > >     struct ext4_filename fname;
> > >     int     retval;
> > >     int     dx_fallback=0;
> > > @@ -2190,9 +2187,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> > >             return -EINVAL;
> > >
> > >  #ifdef CONFIG_UNICODE
> > > -   sbi = EXT4_SB(sb);
> > > -   if (ext4_has_strict_mode(sbi) && IS_CASEFOLDED(dir) &&
> > > -       sbi->s_encoding && utf8_validate(sbi->s_encoding, &dentry->d_name))
> > > +   if (sb_has_strict_encoding(sb) && IS_CASEFOLDED(dir) &&
> > > +       sb->s_encoding && utf8_validate(sb->s_encoding, &dentry->d_name))
> > >             return -EINVAL;
> >
> > hm, just noticed the sb->s_encoding check here is superfluous, since the
> > has_strict_mode() cannot be true if !s_encoding.  Not related to this
> > patch though.
> >
> > Daniel, are you still working on getting this upstream?  The fscrypt
> > support would be very useful for us. :)
> >
> > In the hope this will get upstream, as its been flying for a while and
> > looks correct.
> >
> > Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>
> We couldn't get a response from Ted, so instead Jaegeuk has applied patches 1-3
> to f2fs/dev for 5.10.  Hopefully Ted will take the ext4 patch for 5.11.
>
> I believe that Daniel is planning to resend the actual encryption+casefolding
> support soon, but initially only for f2fs since that will be ready first.
>
> - Eric

Yes, planning to send them shortly. Just checking that I've not missed
anything. For the sb_has_strict_encoding, I don't think that's
actually checking s_encoding, though it does check s_encoding_flags.
I'm planning to resend this one with that set, since it's not queued
in the f2fs tree.

-Daniel
