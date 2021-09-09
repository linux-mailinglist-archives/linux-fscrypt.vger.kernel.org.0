Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007BD404248
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 02:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348475AbhIIA1w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 20:27:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235458AbhIIA1w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 20:27:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1890FsTo006214
        for <linux-fscrypt@vger.kernel.org>; Wed, 8 Sep 2021 17:26:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=IUiZtzJVo510cvF9kp5tB2+3hBLkcpbNWzfKcgVOspQ=;
 b=iDx+P9mtoH8o9N6IpnoJXs61mELEHw9bvyaTLkTI/9Cq6sDiRXCQWh20yv2Hlk1KZA8f
 M66f/nbVSOKuav2vw7FY79z/2a8KVgMNWibcGHwLcnGAXRgS3cxnDX+10fFWMo68nmXd
 N4twlRmFdbMKhdx18xzrg8C2g4Ell2d5gBg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcmw9m9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Sep 2021 17:26:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 8 Sep 2021 17:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUogjuk6oRyXHzECyrNQxQxdc5lOSxmXiWAa+wGvpGb/JkYnJiJj2ZASXIdqOnLo5x0Qd5+95ykamIoqwyPFJZSQwfD6hr8co1lRCyUSNNgJEjszJda5h9SiwSrvGoMa3zLQsFlqr/GvYCa8VY4awVkHE/PDC3F8DViiy05bYzf1Xl0RL7kkmRsoJDyiZIbh5qjgYevpBTaQ/Lzn5U07omojpHgp49QNeZAfxgr65NjZAxYTb/g+x23+Wi4lmgtSYC1Lmrt4Xg5mPEVv/Ug/DuZ9L5OketgtkMvnWc6eFv38F1uXAUQjJcc2J6h81sIrwkpGD6sGrne/u9kHfxuRdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IUiZtzJVo510cvF9kp5tB2+3hBLkcpbNWzfKcgVOspQ=;
 b=F3PI399RiNDzHpI4l81h00gG0E3BRk3SqdB7ZifySJcQ4hT50Cka67v61iY5WG1+OZNzXrtFyELTq/elkqJWiNbx0tHKZyNDPuIqk9tsLV5Y25bLqR+LH3gh6rrPdiT9xpnRRWVgaH8tt5IIb6IIkmvW12j/vNlVL65ixd2H03tuWt0zzffSAhUbZNMZGTkt5a4eWqXOd7mxilS0QAFKA+hmni11FEGO76BUQSqXyWHfqOKq3+SjS76Ln23gFySphiJ3m3ZQSfEq/uEEAM2G5oIoHaNXU1ZjJD/swrTk+NG9IO6VeRBO6+FbKcSUsO01y7V1vwPqlhZVF/1QuYzcSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SN6PR1501MB4142.namprd15.prod.outlook.com (2603:10b6:805:e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:26:40 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 00:26:40 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v3] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Topic: [fsverity-utils PATCH v3] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Index: AQHXpQwfjMohoRpDaEGgoKpad/hQ66ua2H7u
Date:   Thu, 9 Sep 2021 00:26:40 +0000
Message-ID: <SA1PR15MB48246DFCE58AFB521F4CBF95DDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <20210908234851.4056025-1-olo@fb.com>
In-Reply-To: <20210908234851.4056025-1-olo@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 4ad6cf92-3fe0-e572-4d19-8405569cde07
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 402f6b2a-f8a8-42cd-ff1d-08d973287e53
x-ms-traffictypediagnostic: SN6PR1501MB4142:
x-microsoft-antispam-prvs: <SN6PR1501MB4142FD812D44B61B63667DE4DDD59@SN6PR1501MB4142.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HARy0V7mdjCunjEzCkKQmTZR445eKt6NuPBj0qiu5XqJK6D8tDsFa1jc63v4rgz2GpoRQ8rMg0U4Mw5XWBv6uwiApJ17Yj3bGEnfJMJO08EqzGcDAqNUVuUVIqbdqZcgkwxebsH+tLWB+5mRRUvkdX1q2/amj8ERQDluNQa6de+HDw0dFY0xcKfl568rcZXzCPwa/Ry851jOQX2ZCscONQVKFNucOeMr0fNdmPrhiusYifJLsgy0BKEukW05ED2mm7h7nzMNxO/ROJeinMFMvk/rPPIxjuB8Sr653wcUa4zNyHUb2UOuFjMcamFQtdaHVvvvXt+BDHJWMBPYQac1nThMZf9MSte9ax8+qxZk4gGECb/DRVV+I4GfV0YyzTxkDNIw1dweTMlPqMhXMmfKbIShtCGbeeSVRS9v4QtBB83W8T6eD6tgsX8U3MGJyAM5hTme5YwRO6Mmkf2f95lZfHH8wc+Zl/Pi5QeqxC2UgN6DOZbccGolYkpDkyuGdkea8CF/YdO59KLf00RWbakL0fca7fPwF1L5b3tIXmcBw2SzQoV2E9PR/5d1FIM8DBm9XvNBN4CkYasl/lNSDDCI0Z5BfzXXNLQou6UgoA0fqsx9qOeDVrn+oL+r2F0HYu0d0VTB5b9L0EstL5dHBexx/PeLOstpAnudFAgoMop+YIYCsoK2csKM5d2hdZjjWshmWXusIvw6WLahpG0D0laP2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(8676002)(52536014)(30864003)(8936002)(5660300002)(71200400001)(9686003)(33656002)(86362001)(55016002)(76116006)(66946007)(83380400001)(38070700005)(91956017)(38100700002)(122000001)(66556008)(7696005)(53546011)(64756008)(6506007)(66446008)(6916009)(478600001)(186003)(316002)(2906002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9F+mBk5Fri0/Npr+LrAtiCzsXcUpZFfgD7db3dZSOgiK85DuntGhKgW2N57m?=
 =?us-ascii?Q?tT1UDgWoHAUfh5iKMdpAUy3zaR7+K2hhXtP9PZu5X67+mUKgxeZBkY3Ik1Hl?=
 =?us-ascii?Q?xnTfOUHl94w3JF7s18BEDTlA1qb8nKi/hqhrAOEJJcExaWXtEBTq7FsSBX65?=
 =?us-ascii?Q?8VIwERBMtnxEtgdYI8Rcv6/n7KAf6BPfF8fBt2UgTE+mOfSPGf26TzJQsqZV?=
 =?us-ascii?Q?mraxNH2VlHVnYrnuI+akLvOCpIBsUx18v+21KhZ1peW6lCsoMvFz6u6tWeGC?=
 =?us-ascii?Q?mvNKJL1nVYQK+8LAboZC6hyRKmVVGe9Wvm6G+jGHJDQPEgc0ITUHRgva8AP2?=
 =?us-ascii?Q?ElfUKDlGcKm6nmzG6TuSHmXpQ8e6t/TXuhU802kfkqc7cCCL8z6V9n/Xv3/0?=
 =?us-ascii?Q?V915JASNqY7soXc8hhA1gi+3q/oXd7UBC7a1JdC8eILmutPfOhUns4gRmjrM?=
 =?us-ascii?Q?y4L7wei6ShSMXKITQ/wJULTYBKmwWZY7NQ7GpeEGd/VANNrDXaDk7N8D82wT?=
 =?us-ascii?Q?58IsPamaVhT6CaN5bHWkev8S5f0R0dL5E7cwXBAz/ekwm2ZsnlotskLbdQ66?=
 =?us-ascii?Q?VepZ6kGQut1mHLYjPTtG9eP5qvdsdtX6n/u3jZ8d/9V+1+iDAFkeW7MJvjyc?=
 =?us-ascii?Q?58uLHu16gZN4OQN+cBoWDscwGvYALa4vpbw+O5Mbwlz0xqzhBTvBVO8P5xG3?=
 =?us-ascii?Q?9xFruZLqe4baS1I4M0emL8Adx5DT/IZeWH7Qp6iR5EySciRqHYvetSCfOKYm?=
 =?us-ascii?Q?4dTfYP96aWLg6ugFu25faSoWGkdt8XUUFNBIJ6vHF+3VWgQ1HZSe+QV+6/om?=
 =?us-ascii?Q?n3hffnDvbZuewScpSJ5Vk+3CFh20h2NEzBouWtb1OWIiTUyfnai7a4IWXCKL?=
 =?us-ascii?Q?Nndmk0mVrAyZIiKxeOLn0m85g9E0D6nzwGXNYC3xXfBDrh+9ctop+TE7V6xI?=
 =?us-ascii?Q?dhJFJe4/5SMxo4oX0OQ5pdP2sD/4kjQGPIhVp2JTrRvyRkNCFd24UWfKpcMA?=
 =?us-ascii?Q?YD2Y1ShG6nQqrBsvAWAJoo+GouAw+H+hfjhGHyVQLNuUvbzUhuu264U6lk9Y?=
 =?us-ascii?Q?4n+FS4gbOc6uECSu1X08zYJjsg7gAAar8mlGAQ49cLBwsFHzFQhBLUZv3taX?=
 =?us-ascii?Q?DG+plDUHHyBzcD9RqOCTBdyyvlewBgTCAoJ3tOxQaxTK0Iktmof+GXsggUSm?=
 =?us-ascii?Q?MBXN1X6od9a0siYn1AMPyABgq+h2NTQ+JlHF0TMF13TpTzFS3jx3PuDmIdp5?=
 =?us-ascii?Q?6E2G9wS/zMbm58dThth6dAGYR2RAT/3tEfaExRhzeqRjKArfzFff/Q0yfrCY?=
 =?us-ascii?Q?CQhQ5sBK0Uiy96Cp1Evw8S33hJVyU9vOY9YBmYKkn2jb1g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402f6b2a-f8a8-42cd-ff1d-08d973287e53
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 00:26:40.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8vnjD3S7+Ne2Wry1UVYW/r8IdW4u7ph6XCSeu0lJteo63VeqDupeFRUBWZmQjz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4142
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: GPbxB7-zRgIflb62yuRnyCKL_13BAiO4
X-Proofpoint-GUID: GPbxB7-zRgIflb62yuRnyCKL_13BAiO4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_10:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Please disregard this patch, I'm working on V4 in response to Eric's feedback.

________________________________________
From: Aleksander Adamowski <olo@fb.com>
Sent: Wednesday, September 8, 2021 4:48 PM
To: linux-fscrypt@vger.kernel.org
Cc: Aleksander Adamowski
Subject: [fsverity-utils PATCH v3] Implement PKCS#11 opaque keys support through OpenSSL pkcs11 engine

PKCS#11 API allows us to use opaque keys confined in hardware security
modules (HSMs) and similar hardware tokens without direct access to the
key material, providing logical separation of the keys from the
cryptographic operations performed using them.

This commit allows using the popular libp11 pkcs11 module for the
OpenSSL library with `fsverity` so that direct access to a private key
file isn't necessary to sign files.

The user needs to supply the path to the engine shared library
(typically libp11 shared object file) and the PKCS#11 module library (a
shared object file specific to the given hardware token).

Additionally, the existing `key` argument can be used to pass an
optional token-specific key identifier (instead of a private key file
name) for tokens that can contain multiple keys.

Test evidence with a hardware PKCS#11 token:

  $ echo test > dummy
  $ ./fsverity sign dummy dummy.sig \
    --pkcs11-engine=/usr/lib64/engines-1.1/libpkcs11.so \
    --pkcs11-module=/usr/local/lib64/pkcs11_module.so \
    --cert=test-pkcs11-cert.pem && echo OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
  OK

Test evidence for regression check (checking that regular file-based key
signing still works):

  $ ./fsverity sign dummy dummy.sig --key=key.pem --cert=cert.pem && \
    echo  OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
  OK

Signed-off-by: Aleksander Adamowski <olo@fb.com>
---
 include/libfsverity.h |  6 ++-
 lib/sign_digest.c     | 96 ++++++++++++++++++++++++++++++++++++++++---
 man/fsverity.1.md     | 23 ++++++++++-
 programs/cmd_sign.c   | 28 +++++++++++--
 programs/fsverity.c   |  4 +-
 programs/fsverity.h   |  2 +
 6 files changed, 145 insertions(+), 14 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 6cefa2b..4b34f43 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -82,10 +82,12 @@ struct libfsverity_digest {
 };

 struct libfsverity_signature_params {
-       const char *keyfile;            /* path to key file (PEM format) */
+       const char *keyfile;    /* path to key file (PEM format), optional */
        const char *certfile;           /* path to certificate (PEM format) */
        uint64_t reserved1[8];          /* must be 0 */
-       uintptr_t reserved2[8];         /* must be 0 */
+       const char *pkcs11_engine;      /* path to PKCS#11 engine .so, optional */
+       const char *pkcs11_module;      /* path to PKCS#11 module .so, optional */
+       uintptr_t reserved2[6];         /* must be 0 */
 };

 struct libfsverity_metadata_callbacks {
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 9a35256..f0830f3 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -17,6 +17,9 @@
 #include <openssl/err.h>
 #include <openssl/pem.h>
 #include <openssl/pkcs7.h>
+#ifndef OPENSSL_IS_BORINGSSL
+#include <openssl/engine.h>
+#endif
 #include <string.h>

 static int print_openssl_err_cb(const char *str,
@@ -81,6 +84,10 @@ static int read_certificate(const char *certfile, X509 **cert_ret)
        X509 *cert;
        int err;

+       if (!certfile) {
+               libfsverity_error_msg("certfile must be specified");
+       }
+
        errno = 0;
        bio = BIO_new_file(certfile, "r");
        if (!bio) {
@@ -214,6 +221,37 @@ out:

 #else /* OPENSSL_IS_BORINGSSL */

+static ENGINE *get_pkcs11_engine(const char *pkcs11_engine,
+                                const char *pkcs11_module)
+{
+       ENGINE *engine;
+
+       ENGINE_load_dynamic();
+       engine = ENGINE_by_id("dynamic");
+       if (!engine) {
+               error_msg_openssl(
+                   "failed to initialize OpenSSL PKCS#11 engine");
+               return NULL;
+       }
+       if (!ENGINE_ctrl_cmd_string(engine, "SO_PATH", pkcs11_engine, 0) ||
+           !ENGINE_ctrl_cmd_string(engine, "ID", "pkcs11", 0) ||
+           !ENGINE_ctrl_cmd_string(engine, "LIST_ADD", "1", 0) ||
+           !ENGINE_ctrl_cmd_string(engine, "LOAD", NULL, 0) ||
+           !ENGINE_ctrl_cmd_string(engine, "MODULE_PATH", pkcs11_module, 0) ||
+           !ENGINE_init(engine)) {
+               error_msg_openssl(
+                   "failed to initialize OpenSSL PKCS#11 engine");
+               ENGINE_free(engine);
+               return NULL;
+       }
+       /*
+        * engine now holds a functional reference after ENGINE_init(), free
+        * the structural reference from ENGINE_by_id()
+        */
+       ENGINE_free(engine);
+       return engine;
+}
+
 static BIO *new_mem_buf(const void *buf, size_t size)
 {
        BIO *bio;
@@ -317,6 +355,57 @@ out:

 #endif /* !OPENSSL_IS_BORINGSSL */

+/* Get a private key - either off disk or PKCS#11 token */
+static int
+get_private_key(const struct libfsverity_signature_params *sig_params,
+               EVP_PKEY **pkey_ret)
+{
+       if (sig_params->pkcs11_engine || sig_params->pkcs11_module) {
+#ifdef OPENSSL_IS_BORINGSSL
+               libfsverity_error_msg(
+                   "BoringSSL doesn't support PKCS#11 feature");
+               return -EINVAL;
+#else
+               ENGINE *engine;
+
+               if (!sig_params->pkcs11_engine) {
+                       libfsverity_error_msg(
+                           "missing PKCS#11 engine parameter");
+                       return -EINVAL;
+               }
+               if (!sig_params->pkcs11_module) {
+                       libfsverity_error_msg(
+                           "missing PKCS#11 module parameter");
+                       return -EINVAL;
+               }
+               engine = get_pkcs11_engine(sig_params->pkcs11_engine,
+                                          sig_params->pkcs11_module);
+               if (!engine)
+                       return -EINVAL;
+               /*
+                * We overload the keyfile parameter as an optional PKCS#11 key
+                * identifier.  NULL will cause the engine to use the default
+                * key from the token.
+                */
+               *pkey_ret = ENGINE_load_private_key(engine, sig_params->keyfile,
+                                                   NULL, NULL);
+               ENGINE_finish(engine);
+               if (!*pkey_ret) {
+                       error_msg_openssl(
+                           "failed to load private key from PKCS#11 token");
+                       return -EINVAL;
+               }
+               return 0;
+#endif
+       }
+       if (!sig_params->keyfile) {
+               error_msg_openssl(
+                   "missing keyfile parameter (or PKCS11 parameters)");
+               return -EINVAL;
+       }
+       return read_private_key(sig_params->keyfile, pkey_ret);
+}
+
 LIBEXPORT int
 libfsverity_sign_digest(const struct libfsverity_digest *digest,
                        const struct libfsverity_signature_params *sig_params,
@@ -334,11 +423,6 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
                return -EINVAL;
        }

-       if (!sig_params->keyfile || !sig_params->certfile) {
-               libfsverity_error_msg("keyfile and certfile must be specified");
-               return -EINVAL;
-       }
-
        if (!libfsverity_mem_is_zeroed(sig_params->reserved1,
                                       sizeof(sig_params->reserved1)) ||
            !libfsverity_mem_is_zeroed(sig_params->reserved2,
@@ -353,7 +437,7 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
                return -EINVAL;
        }

-       err = read_private_key(sig_params->keyfile, &pkey);
+       err = get_private_key(sig_params, &pkey);
        if (err)
                goto out;

diff --git a/man/fsverity.1.md b/man/fsverity.1.md
index e1007f5..f44aeb0 100644
--- a/man/fsverity.1.md
+++ b/man/fsverity.1.md
@@ -169,8 +169,27 @@ Options accepted by **fsverity sign**:
 :   Same as for **fsverity digest**.

 **\-\-key**=*KEYFILE*
-:   Specifies the file that contains the private key, in PEM format.  This
-    option is required.
+:   Specifies the file that contains the private key, in PEM format.  If any
+    PKCS#11 options are used, it can be used instead to specify the key
+    identifier in the form of PKCS#11 URI.  This option is required when
+    private key is read from disk and optional when using a PKCS#11 token.
+
+**\-\-pkcs11-engine**=*SOFILE*
+:   Specifies the path to the OpenSSL engine library to be used, when a PKCS#11
+    cryptographic token is used instead of a private key file. Typically it
+    will be a path to the libp11 .so file.  This option is required when
+    **\-\-pkcs11-module** is used.
+
+    Note that this option is only supported with classical OpenSSL, and not
+    BoringSSL.
+
+**\-\-pkcs11-module**=*SOFILE*
+:   Specifies the path to the token-specific module library, when a PKCS#11
+    cryptographic token is used instead of a private key file.  This option is
+    required when **\-\-pkcs11-engine** is used.
+
+    Note that this option is only supported with classical OpenSSL, and not
+    BoringSSL.

 **\-\-out-descriptor**=*FILE*
 :   Same as for **fsverity digest**.
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 81a4ddc..064a99b 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -34,6 +34,8 @@ static const struct option longopts[] = {
        {"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
        {"key",             required_argument, NULL, OPT_KEY},
        {"cert",            required_argument, NULL, OPT_CERT},
+       {"pkcs11-engine",           required_argument, NULL, OPT_PKCS11_ENGINE},
+       {"pkcs11-module",           required_argument, NULL, OPT_PKCS11_MODULE},
        {NULL, 0, NULL, 0}
 };

@@ -68,6 +70,12 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
                        }
                        sig_params.keyfile = optarg;
                        break;
+               case OPT_PKCS11_ENGINE:
+                       sig_params.pkcs11_engine = optarg;
+                       break;
+               case OPT_PKCS11_MODULE:
+                       sig_params.pkcs11_module = optarg;
+                       break;
                case OPT_CERT:
                        if (sig_params.certfile != NULL) {
                                error_msg("--cert can only be specified once");
@@ -86,12 +94,26 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
        if (argc != 2)
                goto out_usage;

-       if (sig_params.keyfile == NULL) {
-               error_msg("Missing --key argument");
+       if (sig_params.keyfile == NULL && sig_params.pkcs11_engine == NULL &&
+           sig_params.pkcs11_module == NULL) {
+               error_msg("Missing --key argument or a pair of --pkcs11-engine "
+                         "and --pkcs11-module");
                goto out_usage;
        }
-       if (sig_params.certfile == NULL)
+       if (sig_params.certfile == NULL) {
+               if (sig_params.keyfile == NULL) {
+                       error_msg(
+                           "--cert must be specified when PKCS#11 is used");
+                       goto out_usage;
+               }
                sig_params.certfile = sig_params.keyfile;
+       }
+       if ((sig_params.pkcs11_engine == NULL) !=
+           (sig_params.pkcs11_module == NULL)) {
+               error_msg("Both --pkcs11-engine and --pkcs11-module must be "
+                         "specified when used");
+               goto out_usage;
+       }

        if (!open_file(&file, argv[0], O_RDONLY, 0))
                goto out_err;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index f6aff3a..a4e8f5b 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -58,7 +58,9 @@ static const struct fsverity_command {
                .func = fsverity_cmd_sign,
                .short_desc = "Sign a file for fs-verity",
                .usage_str =
-"    fsverity sign FILE OUT_SIGFILE --key=KEYFILE\n"
+"    fsverity sign FILE OUT_SIGFILE [--key=KEYFILE]\n"
+"               [--pkcs11-engine=PATH_TO_OPENSSL_ENGINE]\n"
+"               [--pkcs11-module=PATH_TO_OPENSSL_MODULE]\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
 "               [--out-merkle-tree=FILE] [--out-descriptor=FILE]\n"
 "               [--cert=CERTFILE]\n"
diff --git a/programs/fsverity.h b/programs/fsverity.h
index fe24087..eb5ba33 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -33,6 +33,8 @@ enum {
        OPT_OUT_MERKLE_TREE,
        OPT_SALT,
        OPT_SIGNATURE,
+       OPT_PKCS11_ENGINE,
+       OPT_PKCS11_MODULE,
 };

 struct fsverity_command;
--
2.30.2

