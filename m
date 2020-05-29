Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02161E8A29
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2020 23:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgE2Viq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 May 2020 17:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgE2Viq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 May 2020 17:38:46 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9BF2071A;
        Fri, 29 May 2020 21:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590788325;
        bh=tE0uiE2+3bBMtWRXqfGfV9qTFRy4O0X4c3cZONdz6Us=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FR/X5uWt/SX5VwwetokdckrjO3xYCshTrKr7FGh3UbMFBpEQa4jLs3EafgCrS/Rhy
         aLn78Ria2TAChv7kxOnS6r1map6x8egSewewnSWfcqQgePocwMktB6KGRHrmfWSTR2
         ANlAFA60lT5tcnw/JRDDZuX2x4WChEzBW7OjrJAw=
Date:   Fri, 29 May 2020 14:38:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200529213843.GA220669@gmail.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com>
 <20200507180838.GC236103@gmail.com>
 <40600d42-dfa9-b60c-6ce8-0eda6bdf7ddf@linaro.org>
 <20200529171326.GA82398@gmail.com>
 <676394c6-4250-8998-d959-68cd218991e5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676394c6-4250-8998-d959-68cd218991e5@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 29, 2020 at 05:25:47PM -0400, Thara Gopinath wrote:
> > > Hi Eric,
> > > 
> > > I tested this manually on db845c, sm8150-mtp and sm8250-mtp.(I added the dts
> > > file entries for 8150 and 8250).
> > > 
> > > I also ran OsBench test case createfiles[1] on the above platforms.
> > > Following are the results on a non encrypted and encrypted directory on the
> > > same file system(lower the number better)
> > > 
> > > 			8250-MTP	8150-MTP	DB845
> > > 
> > > nonencrypt_dir(us) 	55.3108954	26.8323124    69.5709552
> > > encrypt_dir(us) 	70.0214426	37.5411254    92.3818296
> > > 
> > > 
> > > 
> > > 1. https://github.com/mbitsnbites/osbench/blob/master/README.md
> > > 
> > 
> > Great, thanks for testing.
> > 
> > Note that the benchmark you ran (creating many small files, then deleting them)
> > mostly tests the performance of filenames encryption and directory operations,
> > not file contents encryption.  Inline encryption is only used for file contents.
> > 
> > In fact, since that benchmark doesn't sync the files before deleting them, there
> > is no guarantee that any file contents are actually written to disk, and hence
> > no guarantee that inline encryption got used at all.
> 
> Hi Eric,
> 
> The results are particularly interesting if you think a sync is not
> happening. 

You can check the source code
(https://github.com/mbitsnbites/osbench/blob/master/src/create_files.c).
There's no sync.

> There should not be any performance regression in this case
> between the two directories. 

That's not true; the filenames still need to be encrypted.  Filenames encryption
happens right away, not later when the pages are written to disk.  Contents
encryption works differently.

> I can try some reading/writing performance tests rather than creating files
> testing.
> > 
> > It would be more relevant to test the performance of reading/writing file data.
> > 
> > Also, did you try doing any correctness tests?  (See what I suggested earlier.)
> 
> I did correctness test as part of manual tests by diffing the content of the
> copied files and verifying them. I did not run any other tests you
> mentioned. Feel free to add my Tested-by in the next version you send out.
> 

Okay, thanks!

- Eric
