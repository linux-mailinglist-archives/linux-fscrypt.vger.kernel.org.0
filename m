Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432904C3D1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 00:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfFSWoD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 18:44:03 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42878 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfFSWoD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 18:44:03 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so137519ior.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 19 Jun 2019 15:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cqxlS8TUrayOrx9RbCCJk5wRQ9lf+ZHmU1Gk3w573sA=;
        b=Zo1OClAyhkahly1M3GDgTSgP8bluNQ3KeJKArO+j5QmLCtuO3iq7To5FgWOUm2TQ7H
         vnxsuXXb9FhJZEtz7mnlEpM7m6n1QPIJ428Tktag2AvEf3iFS9wxAIQwevEtXysPQXxr
         F17f2AZUvSmIuo5i/y/ioaQFG2wivHpLH4+EtPD22dBE/YkIIjVt+yMpQen2bEnocUab
         FlWffctvJ22Z82i77vdnmcRkbW14uOwLDAl5ZTFsiJ8BEqN+yEbdvCxmOTWd3BZzqbEx
         Gzixhlz8c1YWVEXGT1+zas646xkbxUlm93S+2MSNB91B0zxwF05m7IK3rQGMrVuJFdFS
         U0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cqxlS8TUrayOrx9RbCCJk5wRQ9lf+ZHmU1Gk3w573sA=;
        b=Fkud4muScmWJlleQ6oA5NGOrQer3FSB7ayawcqmImmdfJRMhWBa6IYf6mkM1UEj32g
         s3e1nBrE0CFWajfVe+SQKUncbwYAGLGWxusik2pBhunPn3yAoXDz9imsiJuHOcDmofGh
         iLVre3Ly9n2Qfg9C3u2yIdFmLZg9A8CvEVdtIvDA3fAntlqCzJ/IGHyLUAAfjNjMvxpT
         i8+LdNhYZDANnRfyXLlag8zRoPoRDTv71qua6bCbqOR+dsjU83QB1KpvWva5YFduSzOG
         zllMNgtLtRnB3/kEsfgF2U7b2QvH1HCj/3uH6JuVy6+2HBwESd3fwHfDY6Df0Yqmrubz
         kShA==
X-Gm-Message-State: APjAAAUVGsOMjtBvRNcF9q8yB/qQY/FIuGg/r29zfVcLMeTr2YhhNgd9
        DQq47/JIuSMpqelxCnckvSiyfN4yk8XBGs7cWD/CWw==
X-Google-Smtp-Source: APXvYqw/sCUfskyBvggMUZjvIJpXali3ibXg+KltmWlgJQ0z55nAS0Yzei1eJqAONy0eZ2XuO0dBunkxkRJM9M2L9to=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr13301247iom.283.1560984242534;
 Wed, 19 Jun 2019 15:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-7-ard.biesheuvel@linaro.org> <20190619223710.GC33328@gmail.com>
In-Reply-To: <20190619223710.GC33328@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 00:43:50 +0200
Message-ID: <CAKv+Gu8_iPOA58xP+y-UvF7SPt86uYZZRb0Z9jEHo3d3Q6PhCg@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 20 Jun 2019 at 00:37, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jun 19, 2019 at 06:29:21PM +0200, Ard Biesheuvel wrote:
> > Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
> > skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> > This avoids a separate call into the AES cipher for every invocation.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> I'm not sure we should bother with this, since fscrypt normally uses AES-256-XTS
> for contents encryption.  AES-128-CBC-ESSIV support was only added because
> people wanted something that is fast on low-powered embedded devices with crypto
> accelerators such as CAAM or CESA that don't support XTS.
>
> In the case of Android, the CDD doesn't even allow AES-128-CBC-ESSIV with
> file-based encryption (fscrypt).  It's still the default for "full disk
> encryption" (which uses dm-crypt), but that's being deprecated.
>
> So maybe dm-crypt users will want this, but I don't think it's very useful for
> fscrypt.
>

If nobody cares, we can drop it. I don't feel too strongly about this,
and since it is on the mailinglist now, people will be able to find it
and ask for it to be merged if they have a convincing use case.
