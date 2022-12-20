Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1490652803
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Dec 2022 21:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiLTUky (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 20 Dec 2022 15:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLTUkx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 20 Dec 2022 15:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C650ABF76
        for <linux-fscrypt@vger.kernel.org>; Tue, 20 Dec 2022 12:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671568812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ub9kmgRrjISpMhe6Sg8BlaMxxTikMkHXzfI5S0LY9JM=;
        b=OtFw9zVAqgkS0vFQBZRcOVPNSvVue6yNoWfPvksSamiqHC34pEdv+5TmF8PZFE+9RD3QyA
        ywxFD0FNguultid9D03iuXHpdYDrlVatuXy9Mtz+O2tGrMmlLFI680JUeAn+6WpEHFOmXB
        ACnmkif1cwXX4SRjPK1kw/l7d3PIChY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-34-d9eLPDPiOMSIEZnOW9AG3w-1; Tue, 20 Dec 2022 15:40:11 -0500
X-MC-Unique: d9eLPDPiOMSIEZnOW9AG3w-1
Received: by mail-pf1-f200.google.com with SMTP id a18-20020a62bd12000000b0056e7b61ec78so7319565pff.17
        for <linux-fscrypt@vger.kernel.org>; Tue, 20 Dec 2022 12:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ub9kmgRrjISpMhe6Sg8BlaMxxTikMkHXzfI5S0LY9JM=;
        b=rVjrq4AQ2itXbRJgz7QaZpHRKMq10LdG5cDrcgKq+xOlvmy3rotUX2i7k30EQIwK08
         W3xKnH1s/DrtrJOydHkz9HekPhrcF2EXBkVYhKmkXzJtW/RlvBGdrowZxt6n30vBu13o
         gi3DIX6AtlmHTXwNM2KdOZ/cWhgQ+9hfksnlulYowjj0CiZxQClJLn4n8Ln7SFIM3Y+P
         CuvdZaK4SnmAN8dFMcqucTeNvH1zqHtrL3rBA17P3jEWue1Nsmg2T64/R21PWrS+SfkS
         fORquQajWVAfv1RMJ5HJE2udGWvuT2YSs079T9VY0uOEY52bk+1up/6Au4h9S9XPJJ1y
         P1tQ==
X-Gm-Message-State: ANoB5pna2DV4H+2882RoTrvfNWpAETV+tBv8WSJOvOF/YpQKQ7i2jm4z
        rWoFdxc4RlOzJr/My36VvGNHKtSkn/D7JJ9FJHrcK6mhuJaxrf8OZleBLtto5dKw4rGoW80OM8Q
        qXU7GCwJ5KthS5mCEHjvGuEk31Q==
X-Received: by 2002:a17:902:aa01:b0:189:ed57:9b0d with SMTP id be1-20020a170902aa0100b00189ed579b0dmr40221211plb.44.1671568810363;
        Tue, 20 Dec 2022 12:40:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf58uaUYypg0jacPelIeOoVsfAqxP39jIZpWUDwvFHo77z0TqT/ZtUMPujE+W2lcq9ClObiGrw==
X-Received: by 2002:a17:902:aa01:b0:189:ed57:9b0d with SMTP id be1-20020a170902aa0100b00189ed579b0dmr40221189plb.44.1671568809956;
        Tue, 20 Dec 2022 12:40:09 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902ed8b00b00191152c4c6esm6464836plj.152.2022.12.20.12.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 12:40:09 -0800 (PST)
Date:   Wed, 21 Dec 2022 04:40:05 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 09/10] generic/624: test multiple Merkle tree block sizes
Message-ID: <20221220204005.f4yhfy5dwmgpbvtn@zlang-mailbox>
References: <20221211070704.341481-1-ebiggers@kernel.org>
 <20221211070704.341481-10-ebiggers@kernel.org>
 <20221220065604.eorvm6nlzamh6tyt@zlang-mailbox>
 <Y6FrpRypj1/oFND9@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6FrpRypj1/oFND9@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 20, 2022 at 12:00:37AM -0800, Eric Biggers wrote:
> On Tue, Dec 20, 2022 at 02:56:04PM +0800, Zorro Lang wrote:
> > > +# Always test FSV_BLOCK_SIZE.  Also test some other block sizes if they happen
> > > +# to be supported.
> > > +_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=FSV_BLOCK_SIZE"
> > > +test_block_size $FSV_BLOCK_SIZE
> > > +for block_size in 1024 4096 16384 65536; do
> > > +	_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=$block_size"
> > > +	if (( block_size == FSV_BLOCK_SIZE )); then
> > > +		continue
> > > +	fi
> > > +	if ! _fsv_can_enable $fsv_file --block-size=$block_size; then
> > > +		echo "block_size=$block_size is unsupported" >> $seqres.full
> > > +		continue
> > 
> > If a block size isn't supported, e.g. 1024. Then this case trys to skip that
> > test, but it'll break golden image, due to the .out file contains each line
> > of:
> >   Testing FS_IOC_READ_VERITY_METADATA with block_size=1024/4096/16384/65536
> > 
> > Do you expect that failure, or we shouldn't fail on that?
> 
> Actually it doesn't fail, since "Testing FS_IOC_READ_VERITY_METADATA with
> block_size=$block_size" is printed unconditionally, and
> "block_size=$block_size is unsupported" is only printed to $seqres.full.

Oh, you're right.

> 
> To avoid this confusion, how about I change "Testing FS_IOC_READ_VERITY_METADATA
> with block_size=$block_size" to "Testing block_size=$block_size if supported"?
> Or do you have another suggestion?

That's fine, I think current "output" is good to me. If there's not objection
from linux-fscrypt@, I'll merge this patchset. Thanks for this update.

Thanks,
Zorro

> 
> - Eric
> 

