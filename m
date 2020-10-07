Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43F5286AA4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 00:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgJGWFH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 18:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbgJGWFH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 18:05:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C624C0613D2
        for <linux-fscrypt@vger.kernel.org>; Wed,  7 Oct 2020 15:05:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g9so2472933pgh.8
        for <linux-fscrypt@vger.kernel.org>; Wed, 07 Oct 2020 15:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+V7sZxEf6mQQioi6/3fm4YR6csX1PamPT+xsX7pNB4w=;
        b=ep50T10dpOtQ6OLVV05z3OtJ/y5qq6xfZST1mEKfChwtiRhcO3i/N4I2jdp9MNovJk
         pCKOd/eZwaZnV2KWv1TUqBmy/Gu3YCAdmn2W/P9tqvR4EIUmxSfRR6oCT2+UptOCoxYz
         osAjjmkEmMm2ID+cJZ0TEfmtLYQNdpmmgQWnYXDtNwOxdB1HwOy81zc8y87p/ql4aEtl
         rungVNTAaNvn1+j6w2VrV74FMWuiEcg/Ls9u87zllfaWoUrX3uD8c/ssBHk0n6iMSXZf
         YFqgZdHZe4pPhylbuYcrd9eAzzNaQKbFJKRMvAJcT1fwFcThuz2o76vhh/JvTLhtvJ97
         Bt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+V7sZxEf6mQQioi6/3fm4YR6csX1PamPT+xsX7pNB4w=;
        b=o5Tn+J91h4+ZH155TPVWzxGdhyi+dS1FoljXZX1q0Pmn8FmDW4nY/2wtTi8RLYX8kb
         P5eoWF6KmjgU7VRnS/fy5AHXiyWKcV00n76XZAr1N1rBdDJOKvTZ/Uzcd0aVLlg5lGNI
         bVWvpLPTyMbVAmzwnQ1Di/T/r0Gavb9S/WH62lzKyZ/QIbRPIKGD+Z+mQpvnNMLGnVMF
         cVfd4z/W58uA2hm9MNTZRce5qXZM0bLkuHDzCebnSFKlGrNI8YOWilny4U7nTg8P9BTx
         ROHbvTup0co9TWdePXbIO570OtULvowEzHbWobAPfJxNoX5QBxJP0bvntTwWtE9/2fbZ
         ZkgA==
X-Gm-Message-State: AOAM531S/FR49jvl8W1zodxbgRMSjqXPt9GccR9XQGYozcP5kEyryXoA
        YAn+VPcmmjfqfxbIRAknyTmeAg==
X-Google-Smtp-Source: ABdhPJys6F86XrljUH8qz8gcZargaIbvBEZ19MwlhxtUE/XlZ7tHjdwI5A2a2e1IHecb/WpyiWo9OQ==
X-Received: by 2002:a63:4c4e:: with SMTP id m14mr4441454pgl.199.1602108304796;
        Wed, 07 Oct 2020 15:05:04 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id n67sm4425110pgn.14.2020.10.07.15.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 15:05:03 -0700 (PDT)
Date:   Wed, 7 Oct 2020 22:05:00 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <20201007220500.GA2544297@google.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <20201007210040.GB1530638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007210040.GB1530638@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 07, 2020 at 02:00:40PM -0700, Eric Biggers wrote:
> On Mon, Oct 05, 2020 at 07:36:03AM +0000, Satya Tangirala wrote:
> > This patch series adds support for metadata encryption to F2FS using
> > blk-crypto.
> 
> This patch series needs more explanation about what "metadata encryption" is,
> why people will want to use it (as opposed to either not using it, or using
> fscrypt + dm-crypt instead), and why this is the best implementation of it.
> 
Sure, I'll add that in the next version
> > Patch 2 introduces some functions to fscrypt that help filesystems perform
> > metadata encryption. Any filesystem that wants to use metadata encryption
> > can call fscrypt_setup_metadata_encryption() with the super_block of the
> > filesystem, the encryption algorithm and the descriptor of the encryption
> > key. The descriptor is looked up in the logon keyring of the current
> > session with "fscrypt:" as the prefix of the descriptor.
> 
> I notice this is missing the step I suggested to include the metadata encryption
> key in the HKDF application-specific info string when deriving subkeys from the
> fscrypt master keys.
> 
> The same effect could also be achieved by adding an additional level to the key
> hierarchy: each HKDF key would be derived from a fscrypt master key and the
> metadata encryption key.
> 
> We need one of those, to guarantee that the file contents encryption is at least
> as strong as the "metadata encryption".
>
Yes - I didn't get around to that in the first version, but I'll add
that too in the next version. I was going to go with the first approach
before I saw your comment - is there one method you'd recommend going
with over the other?
> - Eric
