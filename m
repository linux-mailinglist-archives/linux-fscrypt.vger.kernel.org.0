Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EB91F8EA9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2020 08:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgFOGva (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Jun 2020 02:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbgFOGv1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Jun 2020 02:51:27 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297942067B;
        Mon, 15 Jun 2020 06:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592203887;
        bh=w7KcDakz00qrDKT+3PtQZ1TMTfHGZvcgWnYT3lZBW60=;
        h=Date:From:To:Cc:Subject:From;
        b=zS/qdo8jfgzfP64P5IT1agUm247hUGFAeKjtri9UwCyUnMmJwBj705ZN1niz3r+JJ
         NquKJ4EoAeXnQtTilv1CZkjH6egDROoXwaHm3LHy/LnJaEHliBRDRPw+ok8pLV9CT9
         oZ64APSoq9K3WwTLp5F19CmKLkPDpXBDW/yoNNw0=
Date:   Sun, 14 Jun 2020 23:51:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Jes Sorensen <jsorensen@fb.com>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [ANNOUNCE] fsverity-utils v1.1
Message-ID: <20200615065125.GB3100@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I've released fsverity-utils v1.1:

Git: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/tag/?h=v1.1
Tarball: https://kernel.org/pub/linux/kernel/people/ebiggers/fsverity-utils/v1.1/

Release notes:

  * Split the file measurement computation and signing functionality
    of the `fsverity` program into a library `libfsverity`.  See
    `README.md` and `Makefile` for more details.

  * Improved the Makefile.

  * Added some tests.  They can be run using `make check`.  Also added
    `scripts/run-tests.sh` which does more extensive prerelease tests.

  * Lots of cleanups and other small improvements.

- Eric
