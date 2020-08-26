Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340702535D3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHZROZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 13:14:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHZROY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 13:14:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QH9ZFS043527;
        Wed, 26 Aug 2020 17:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=yUholIYi4UuEZe2vEuDL0z0NaSsrkG/uF1JQxdoBfxc=;
 b=NQHlKlK4hj6ks6gaCHfRtFoL1bZ81ZeiTDCnXVNKQUaqivnm9kwpkiP5lVzOOSIVuG5z
 LKZ3TBMH0ssTQRmsTCCVRJLXa+8V8N4fbIh1MoYl4BdW3oVc0YREQ/LUG8IzY1Yp/Okm
 AM7VaZ3pdnZDJQEk3ndZupQ49wdCY70CvD787GJnXCa3qO6WHod55pNQDqdG4OmO+761
 e8Ub9UYvQ4zsu28/3g2BJv/jZdXO0za3vrZP7m4P/zzi+L7229kFuOIUcmm6rOubXDtB
 nyquYVn9myLil7ljqozqU6f3yrHgbEx1rhdLdKr1b7B8EW38vOq7ueTTVPbqKLybPfxv 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6u0add-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 17:14:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QHAG10105299;
        Wed, 26 Aug 2020 17:14:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 333ruas1mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 17:14:22 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QHEKQt010997;
        Wed, 26 Aug 2020 17:14:20 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219) by default
 (Oracle Beehive Gateway v4.0) with ESMTP ; Wed, 26 Aug 2020 10:13:44 -0700
MIME-Version: 1.0
Message-ID: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
Date:   Wed, 26 Aug 2020 10:13:43 -0700 (PDT)
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: IMA metadata format to support fs-verity
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260128
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric-

I'm trying to construct a viable IMA metadata format (ie, what
goes into security.ima) to support Merkle trees.

Rather than storing an entire Merkle tree per file, Mimi would
like to have a metadata format that can store the root hash of
a Merkle tree. Instead of reading the whole tree, an NFS client
(for example) would generate the parts of the file's fs-verity
Merkle tree on-demand. The tree itself would not be exposed or
transported by the NFS protocol.

Following up with the recent thread on linux-integrity, starting
here:

  =
https://lore.kernel.org/linux-integrity/1597079586.3966.34.camel@HansenPar=
tnership.com/t/#u

I think the following will be needed.

1. The parameters for (re)constructing the Merkle tree:
- The name of the digest algorithm
- The unit size represented by each leaf in the tree
- The depth of the finished tree
- The size of the file
- Perhaps a salt value
- Perhaps the file's mtime at the time the hash was computed
- The root hash

2. A fingerprint of the signer:
- The name of the digest algorithm
- The digest of the signer's certificate

3. The signature
- The name of the signature algorithm
- The signature, computed over 1.

Does this seem right to you?

There has been some controversy about whether to allow the
metadata to be unsigned. It can't ever be unsigned for NFS files,
but some feel that on a physically secure local-only set up,
signatures could be unnecessary overhead. I'm not convinced, and
believe the metadata should always be signed: that's the only
way to guarantee end-to-end integrity, which includes protection
of the content's provenance, no matter how it is stored.

--
Chuck Lever



